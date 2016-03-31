# == Schema Information
#
# Table name: users
#
#  id             :integer          not null, primary key
#  email          :string(100)
#  roles          :string           is an Array
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  last_active_at :datetime
#  profile        :hstore
#  status         :integer
#  settings       :hstore
#  account_type   :integer
#  nickname       :string
#  level_id       :integer
#  path_id        :integer
#
# Indexes
#
#  index_users_on_level_id  (level_id)
#

class User < ActiveRecord::Base
  NOTIFICATION_SERVICE = Pusher

  attr_accessor :notifier

  belongs_to :level
  has_many :solutions, dependent: :destroy
  has_many :challenges, -> { uniq }, through: :solutions
  has_many :auth_providers, dependent: :destroy
  has_many :lesson_completions
  has_many :subscriptions
  has_many :project_solutions
  has_many :projects, -> { uniq }, through: :project_solutions
  has_many :resource_completions, dependent: :delete_all
  has_many :resources, -> { uniq }, through: :resource_completions
  has_many :points
  has_many :challenge_completions, dependent: :delete_all
  has_many :badge_ownerships, dependent: :destroy
  has_many :badges, -> { uniq }, through: :badge_ownerships
  has_many :notifications
  has_many :comments
  has_many :quiz_attempts, class_name: '::Quizer::QuizAttempt'
  has_many :path_subscriptions
  has_many :paths, -> { uniq }, through: :path_subscriptions

  hstore_accessor :profile,
    first_name: :string,
    last_name: :string,
    gender: :string,
    birthday: :date,
    mobile_number: :string,
    optimism: :string,
    mindset: :string,
    motivation: :string,
    experience: :string,
    activated_at: :datetime,
    github_username: :string,
    suspended: :boolean

  hstore_accessor :settings,
    info_requested_at: :datetime,
    has_public_profile: :boolean

  accepts_nested_attributes_for :path_subscriptions, allow_destroy: true

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :nickname, uniqueness: true
  validates :nickname, format: { with: /\A[a-zA-Z0-9_\-]+\Z/ }, if: :nickname?

  enum status: [:created, :active]
  enum account_type: [:free_account, :paid_account, :admin_account]

  before_create :assign_random_nickname
  after_initialize :default_values
  after_save :check_user_level

  def self.commenters_of(commentable)
    joins(:comments).where(comments: {commentable_id: commentable.id,commentable_type: commentable.class.to_s}).uniq
  end

  def self.with_public_profile
    self.is_has_public_profile
  end

  def self.search(q)
    query_string = q.split.join('%')
    where(%Q(
      LOWER(UNACCENT(profile -> 'first_name')) LIKE LOWER(UNACCENT(:q)) OR
      LOWER(UNACCENT(email)) LIKE LOWER(UNACCENT(:q)) OR
      LOWER(UNACCENT(nickname)) LIKE LOWER(UNACCENT(:q))
    ),q: "%#{query_string}%")
  end

  def completed_challenges
    self.challenges.joins(:solutions).where('solutions.status = ?',Solution.statuses[:completed]).uniq
  end

  def stats
    @stats ||= UserStats.new(self)
  end

  def next_level
    Level.order(:required_points).where("required_points > ?", self.stats.total_points).first
  end

  def is_admin?
    admin_account?
  end

  def resource_completed_at(resource)
    complete = resource_completions.where(resource_id: resource).take
    complete.created_at
  end

  def finished?(course)
    self.stats.progress_by_course(course) == 1.0
  end

  def has_access_to?(resource)
    self.is_admin? || self.paid_account?
  end

  def can_update_comment?(comment)
    self.is_admin? || self == comment.user
  end
  alias_method :can_delete_comment?, :can_update_comment?

  def has_completed_lesson?(lesson)
    !!self.lesson_completions.find_by_lesson_id(lesson.id)
  end

  def has_completed_project?(project)
    !!project.project_solutions.find_by_user_id(self.id)
  end

  def has_completed_challenge?(challenge)
    ChallengeCompletion.exists?(challenge_id: challenge.id,user_id: self.id)
  end

  def has_completed_resource?(resource)
    !!self.resource_completions.find_by_resource_id(resource.id)
  end

  def avatar_url
    Gravatar.new(self.email).image_url
  end

  def send_inscription_info
    UserMailer.inscription_info(self).deliver_now
    self.info_requested_at = Time.current
    save!
  end

  def active_subscription
    self.subscriptions.active.first
  end

  def reset_solution(challenge)
    solution = solutions.where(challenge_id: challenge.id).take
    solution.destroy
    solution = solutions.new(challenge_id: challenge.id)
  end

  def activate!
    self.update!(
      status: User.statuses[:active],
      activated_at: Time.current
    )
  end

  def send_welcome_mail
    SubscriptionsMailer.welcome_mail(self).deliver_now
  end

  def notifier
    @notifier ||= UserNotifier.new(self, User::NOTIFICATION_SERVICE)
  end

  def last_solution
    solutions.order('updated_at DESC').take
  end

  def next_challenge
    # user has not completed nor attempted any challenge
    if last_solution.nil?
      Challenge.for(self).order_by_course_and_rank.first
    # user's last action was a challenge completion
    elsif last_solution.completed?
      find_next_challenge
    # user attempted a challenge but it was not completed
    else
      last_solution.challenge
    end
  end

  def available_paths
    self.paths
  end

  private
    def default_values
      self.roles ||= ["user"]
      self.status ||= :created
      self.has_public_profile ||= false
      self.account_type ||= User.account_types[:free_account]
      self.suspended ||= false
      self.level ||= Level.for_points(0)
    end

    def assign_random_nickname
      if self.nickname.blank?
        begin
          self.nickname = SecureRandom.hex(8)
        end while User.find_by_nickname(self.nickname)
      end
    end

    def check_user_level
      if self.level_id_was != self.level_id
        self.notifications.create!(notification_type: :level_up, data: {level_id: self.level_id})
      end
    end

    def find_next_challenge
      current_challenge = last_solution.challenge
      next_challenge = current_challenge.next_for_user(self)
      if next_challenge
        next_challenge
      else
        solutions.pending.joins(:challenge).where('challenges.published = ?', true).order('updated_at ASC').take.try(:challenge)
      end
    end
end
