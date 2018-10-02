# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(100)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  last_active_at  :datetime
#  profile         :hstore
#  status          :integer
#  settings        :hstore
#  account_type    :integer
#  nickname        :string
#  level_id        :integer
#  password_digest :string
#  access_type     :integer          default(0)
#  current_points  :integer          default(0)
#
# Indexes
#
#  index_users_on_level_id  (level_id)
#

class User < ApplicationRecord
  NOTIFICATION_SERVICE = Pusher

  has_secure_password validations: false
  attr_accessor :notifier

  belongs_to :level
  has_many :solutions, dependent: :destroy
  has_many :challenges, -> { distinct }, through: :solutions
  has_many :auth_providers, dependent: :destroy
  has_many :lesson_completions
  has_many :subscriptions
  has_many :project_solutions
  has_many :projects, -> { distinct }, through: :project_solutions
  has_many :resource_completions, dependent: :delete_all
  has_many :resources, -> { distinct }, through: :resource_completions
  has_many :points
  has_many :challenge_completions, dependent: :delete_all
  has_many :badge_ownerships, dependent: :destroy
  has_many :badges, -> { distinct }, through: :badge_ownerships
  has_many :notifications
  has_many :comments
  has_many :quiz_attempts, class_name: '::Quizer::QuizAttempt'
  has_many :path_subscriptions
  has_many :paths, -> { distinct }, through: :path_subscriptions
  has_many :activity_logs
  has_many :applicant_activities

  hstore_accessor :profile,
    first_name: :string,
    last_name: :string,
    gender: :string,
    birthday: :date,
    mobile_number: :string,
    activated_at: :datetime,
    github_username: :string

  hstore_accessor :settings,
    has_public_profile: :boolean,
    password_reset_token: :string,
    password_reset_sent_at: :datetime,
    has_chat_access: :boolean

  accepts_nested_attributes_for :path_subscriptions, allow_destroy: true

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :password, presence: true, length: { within: 6..40 }, if: -> { password? && password_digest_changed? }
  validates :nickname, uniqueness: true
  validates :nickname, format: { with: /\A[a-zA-Z0-9_\-]+\Z/ }, if: :nickname?

  enum status: [:created, :active, :suspended, :finished]
  enum account_type: [:free_account, :paid_account, :admin_account]
  enum access_type: [:slack, :password]

  before_create :assign_random_nickname
  after_initialize :default_values
  after_save :check_user_level
  after_save :log_activity
  before_save :downcase_email

  def name
    name = ""
    name += self.first_name if self.first_name
    name += " #{self.last_name}" if self.last_name

    name = self.email if name.blank?
    name
  end

  def self.commenters_of(commentable)
    joins(:comments).where(comments: {commentable_id: commentable.id,commentable_type: commentable.class.to_s}).distinct
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
    self.challenges.joins(:solutions).where('solutions.status = ?',Solution.statuses[:completed]).distinct
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

  def finished?(subject)
    self.stats.progress_by_subject(subject) == 1.0
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
      password_reset_token: nil,
      password_reset_sent_at: nil,
      status: User.statuses[:active],
      activated_at: Time.current
    )
  end

  def send_welcome_email
    if self.slack?
      SubscriptionsMailer.welcome_slack(self).deliver_now
    else
      generate_token
      self.password_reset_sent_at = Time.current
      save!
      SubscriptionsMailer.activate(self).deliver_now
    end
  end

  def send_password_reset
    generate_token
    self.password_reset_sent_at = Time.current
    save!
    UserMailer.password_reset(self).deliver_now
  end

 def has_valid_password_reset_token?
   (!!self.password_reset_sent_at) && (self.password_reset_sent_at >= 2.hours.ago)
  end

  def notifier
    @notifier ||= UserNotifier.new(self, User::NOTIFICATION_SERVICE)
  end

  def last_solution
    solutions.order('updated_at DESC').take
  end

  def next_challenge
    if last_solution.nil? # user has not completed nor attempted any challenge
      Challenge.for(self).order_by_subject_and_rank.first
    elsif last_solution.completed? # user's last action was a challenge completion
      find_next_challenge
    else # user attempted a challenge but it was not completed
      last_solution.challenge
    end
  end

  def available_paths
    self.paths
  end

  private
    def default_values
      self.status ||= :created
      self.has_public_profile ||= false
      self.account_type ||= User.account_types[:free_account]
      self.level ||= Level.for_points(0)
    end

    def generate_token
       begin
         self.password_reset_token = SecureRandom.urlsafe_base64
       end while User.exists?(["settings -> 'password_reset_token' = '#{self.settings['password_reset_token']}'"])
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

    def downcase_email
      self.email = self.email.downcase if self.email
    end

    def find_next_challenge
      next_challenge = find_next_challenge_recursively(last_solution.challenge)
      next_challenge || last_pending_challenge
    end

    def find_next_challenge_recursively(current_challenge)
      next_challenge = next_challenge_after(current_challenge)

      if next_challenge && !challenge_attempted?(next_challenge)
        next_challenge
      elsif next_challenge
        find_next_challenge_recursively(next_challenge)
      end
    end

    def challenge_attempted?(challenge)
      solution = solutions.where(challenge: challenge).take
      solution && !solution.created?
    end

    # returns the next published challenge after the one of the argument or nil
    # if it is the last one
    def next_challenge_after(challenge)
      next_challenge_in_subject = next_challenge_in_subject_after(challenge)
      if next_challenge_in_subject
        next_challenge_in_subject
      else
        first_challenge_of_next_subject(challenge.subject)
      end
    end

    # returns the next published challenge after the one of the argument in the
    # same subject or nil if it's the last one
    def next_challenge_in_subject_after(challenge)
      challenge.subject.challenges.for(self).order(:row).where("row > ?", challenge.row).take
    end

    def first_challenge_of_next_subject(current_subject)
      Challenge.for(self).order_by_subject_and_rank.where("subjects.row > ?", current_subject.row).take
    end

    def last_pending_challenge
      solutions.pending.joins(:challenge).where('challenges.published = ?', true).order('updated_at ASC').take.try(:challenge)
    end

    def log_activity
      if status_was == "created" && status == "active" # the user is now active
        segments = ['Students', 'Active Students']
        segments << self.slack? ? 'Virtual' : 'Presencial'
        notify_convertloop(email: self.email, first_name: self.first_name, last_name: self.last_name, add_to_segments: segments) unless Rails.env.test?
        ActivityLog.create(name: "enrolled", user: self, description: "Inició el programa")
      elsif status_was == "active" && status == "suspended" # the account has been suspended
        notify_convertloop(email: self.email, add_to_segments: ['Suspended Students'], remove_from_segments: ['Active Students', 'Virtual', 'Presencial']) unless Rails.env.test?
        ActivityLog.create(name: "account-suspended", user: self, description: "La cuenta ha sido suspendida")
      elsif status_was == "active" && status == "finished" # the user finished the program
        notify_convertloop(email: self.email, add_to_segments: ['Finished Students'], remove_from_segments: ['Active Students']) unless Rails.env.test?
        ActivityLog.create(name: "completed-program", user: self, description: "Terminó el programa!")
      elsif status_was == "suspended" && status == "active" # the account has been reactivated
        notify_convertloop(email: self.email, add_to_segments: ['Active Students'], remove_from_segments: ['Suspended Students']) unless Rails.env.test?
        ActivityLog.create(name:"account-reactivated", user: self, description: "La cuenta ha sido reactivada")
      end
    end

    def notify_convertloop(data)
      ConvertLoop.people.create_or_update(data)
    rescue => e
      Rails.logger.error "Couldn't create or update user #{data[:email]} in ConvertLoop: #{e.message}"
    end
end
