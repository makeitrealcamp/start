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

class Solution < ActiveRecord::Base
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

  scope :evaluated, -> { where(status: [Solution.statuses[:completed], Solution.statuses[:failed] ]) }

  def evaluate
    if self.challenge.ruby_embedded?
      RubyEvaluator.new.evaluate(self)
    elsif self.challenge.phantomjs_embedded?
      PhantomEvaluator.new.evaluate(self)
    elsif self.challenge.ruby_git?
      GitEvaluator.new.evaluate(self)
    elsif self.challenge.rails_git?
      RailsEvaluator.new.evaluate(self)
    elsif self.challenge.sinatra_git?
      SinatraEvaluator.new.evaluate(self)
    elsif self.challenge.ruby_git_pr?
      GitPREvaluator.new.evaluate(self)
    else
      self.status = :failed
      self.error_message = "Hemos encontrado un error en el evaluador, favor reportar a info@makeitreal.camp"
      self.save!
    end

  end

  def as_json(options)
    json = super(options.merge(
      methods: [:error_message, :url, :completed_at],
      include: [:documents]
      ))
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
end
