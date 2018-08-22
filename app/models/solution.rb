# == Schema Information
#
# Table name: solutions
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  challenge_id :integer
#  status       :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  attempts     :integer
#  properties   :hstore
#
# Indexes
#
#  index_solutions_on_challenge_id  (challenge_id)
#  index_solutions_on_user_id       (user_id)
#  solutions_gin_properties         (properties)
#

class Solution < ApplicationRecord
  has_paper_trail on: [:update]

  belongs_to :user
  belongs_to :challenge
  has_many :documents, as: :folder

  enum status: [:created, :completed, :failed, :evaluating]

  hstore_accessor :properties,
    completed_at: :datetime,
    error_message: :string,
    repository: :string,
    pull_request: :integer

  after_initialize :default_values
  after_create :create_documents
  after_save :log_activity
  after_update :create_user_points!

  scope :evaluated, -> { where(status: [Solution.statuses[:completed], Solution.statuses[:failed]]) }
  scope :pending, -> { where(status: [Solution.statuses[:created], Solution.statuses[:failed]]) }

  def evaluate
    evaluator = Evaluator::Factory.create(self)
    if evaluator
      evaluator.prepare
      evaluator.execute unless failed?
      evaluator.clean
    else
      fail_unknown("Hemos encontrado un error en el evaluador, favor reportar a info@makeitreal.camp")
    end
  rescue Exception => e
    fail_unknown(e)
  end

  def fail_unknown(message)
    self.status = :failed
    self.error_message = message
    self.save!
  end

  def as_json(options)
    methods = [:error_message, :completed_at]

    if options.key?(:include_user_level)
      user = methods << :user_hash
    end

    super(options.merge(
      methods: methods,
      include: [:documents]
    ))
  end

  def user_hash
    user_hash = { level_image: user.level.image_url, total_points: user.stats.total_points, level_progress: user.stats.level_progress, points_needed_for_next_level: user.stats.points_needed_for_next_level }

    if user.next_level
      user_hash.merge!(next_level: true, required_points: user.next_level.required_points, next_level_image: user.next_level.image_url)
    end
    user_hash
  end

  def create_user_points!
    if self.completed? && !self.user.has_completed_challenge?(self.challenge)
      self.user.challenge_completions.create!(challenge: self.challenge)
      self.user.points.create!(subject: self.challenge.subject, points: self.challenge.point_value, pointable: self.challenge)
    end
  end

  private
    def default_values
      self.status ||= :created
      self.attempts ||= 0
    end

    def create_documents
      challenge.documents.each do |document|
        documents.create(name: document.name, content: document.content)
      end
    end

    def log_activity
      if status_was.nil? && status == "created"
        description = "Inició #{challenge.to_html_description}"
        ActivityLog.create!(name: "started-challenge", user: user, activity: self, description: description)
      elsif status == "failed" && status_was != "completed"
        description = "Intentó #{challenge.to_html_description}"
        ActivityLog.create!(name: "attempted-challenge", user: user, activity: self, description: description)
      elsif (status_was == "created" || status_was == "failed") && status == "completed"
        description = "Completó #{challenge.to_html_description}"
        ActivityLog.create!(name: "completed-challenge", user: user, activity: self, description: description)
      end
    end
end
