# == Schema Information
#
# Table name: challenges
#
#  id                  :integer          not null, primary key
#  course_id           :integer
#  name                :string(100)
#  instructions        :text
#  evaluation          :text
#  row                 :integer
#  published           :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  slug                :string
#  evaluation_strategy :integer
#  solution_video_url  :string
#  solution_text       :text
#  restricted          :boolean          default(FALSE)
#  preview             :boolean          default(FALSE)
#  pair_programming    :boolean          default(FALSE)
#  difficulty_bonus    :integer
#  timeout             :integer
#
# Indexes
#
#  index_challenges_on_course_id  (course_id)
#

class Challenge < ActiveRecord::Base
  BASE_POINTS = 100
  has_paper_trail on: [:update, :destroy]

  include RankedModel
  ranks :row, with_same: :course_id

  extend FriendlyId
  friendly_id :name

  enum evaluation_strategy: [:ruby_embedded, :phantomjs_embedded, :ruby_git, :rails_git, :sinatra_git, :ruby_git_pr, :async_phantomjs_embedded]

  belongs_to :course
  has_many :documents, as: :folder
  has_many :comments, as: :commentable
  has_many :solutions
  has_many :points, as: :pointable

  validates :name, presence: true
  validates :instructions, presence: true

  scope :published, -> { where(published: true) }

  after_initialize :default_values

  accepts_nested_attributes_for :documents, allow_destroy: true

  before_destroy :check_for_solutions

  def self.for(user)
    if user.is_admin?
      all
    else
      published.where(id: user.available_paths.map{ |path| path.challenges.pluck(:id) }.flatten)
    end
  end

  def self.order_by_course_and_rank
    joins(:course).order(["courses.row","challenges.row"])
  end

  def self.by_course
    Course.all.inject([]) { |memo, course| memo += where(course: course) }
  end

  def self.default_timeouts
    {
      ruby_embedded: 15, phantomjs_embedded: 30, ruby_git: 15, rails_git: 90,
      sinatra_git: 90, ruby_git_pr: 15, async_phantomjs_embedded: 30
    }
  end

  def self.default_timeout_for_evaluation_strategy(strategy)
    default_timeouts[strategy.to_sym]
  end

  def name_with_course
    "#{course.name} - #{name}"
  end

  def to_s
    name
  end

  def point_value
    self.difficulty_bonus + Challenge::BASE_POINTS
  end

  def name_for_notification
    name
  end

  def url_for_notification
    Rails.application.routes.url_helpers.discussion_course_challenge_path(self.course, self)
  end

  private
    def default_values
      self.published ||= false
      self.evaluation ||= "def evaluate(files)\n  \nend"
      self.evaluation_strategy ||= :ruby_embedded
      self.difficulty_bonus ||= 0
      self.timeout ||= 15
    rescue ActiveModel::MissingAttributeError => e
      # ranked_model makes partial selects and this error is thrown
    end

    def check_for_solutions
      if solutions.any?
        errors[:base] << "Cannot delete Challenge because this have solutions associated"
        return false
      end
    end
end
