# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(100)
#  roles           :string           is an Array
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  last_active_at  :datetime
#  profile         :hstore
#  status          :integer
#  settings        :hstore
#  account_type    :integer
#

class User < ActiveRecord::Base
  attr_accessor :password_confirmation
  has_secure_password validations: false

  has_many :solutions, dependent: :destroy
  has_many :auth_providers, dependent: :destroy
  has_many :lesson_completions
  has_many :subscriptions
  has_many :project_solutions
  has_many :resource_completions, dependent: :delete_all

  hstore_accessor :profile,
    first_name: :string,
    gender: :string,
    birthday: :date,
    mobile_number: :string,
    optimism: :string,
    mindset: :string,
    motivation: :string,
    experience: :string,
    activated_at: :datetime,
    github_username: :string

  hstore_accessor :settings,
    password_reset_token: :string,
    password_reset_sent_at: :datetime,
    info_requested_at: :datetime,
    has_public_profile: :boolean

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :password, presence: true, length: { within: 6..40 }, on: :create
  validates :password, presence: true, length: { within: 6..40 }, if: :password_digest_changed?
  validates :password_confirmation, presence: true, on: :create
  validates_confirmation_of :password, on: :create
  validates :password_confirmation, presence: true, on: :update, if: :password_digest_changed?
  validates_confirmation_of :password, on: :update, if: :password_digest_changed?

  enum status: [:created, :active]
  enum account_type: [:free_account, :paid_account, :admin_account]

  after_initialize :default_values

  def has_role?(role)
    roles && roles.include?(role)
  end

  def is_admin?
    admin_account?
  end

  def str_status
    active? ? "Activo" : "Sin Activar"
  end

  def str_optimism
    return "" if optimism.nil?
    optimism == "high" ? "alto" : "bajo"
  end

  def str_account_type
    if free_account?
      "Usuario Free"
    elsif paid_account?
      "Usuario Pago"
    elsif admin_account?
      "Administrador"
    end
  end

  def progress(course)
    resources_count = course.resources.published.count
    challenges_count = course.challenges.published.count
    total = resources_count + challenges_count
    return 1.0 if total == 0
    user_completed = self.completed_resources(course).count + self.completed_challenges(course).count
    user_completed/total.to_f
  end

  def completed_resources(course)
    self.resource_completions.joins(:resource).where('resources.course_id = ? AND resources.published = ?', course.id, true)
  end

  def resource_completed_at(resource)
    complete = resource_completions.where(resource_id: resource).take
    complete.created_at
  end

  def completed_challenges(course)
    self.solutions.completed.joins(:challenge).where('challenges.course_id = ? AND challenges.published = ?', course.id, true)
  end

  def finished?(course)
    progress(course) == 1.0
  end

  #TODO: Remove params, are not using
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
    solution = self.solutions.where(challenge_id: challenge.id).take
    solution && solution.status == "completed"
  end

  def has_completed_resource?(resource)
    !!self.resource_completions.find_by_resource_id(resource.id)
  end

  def send_password_reset
    generate_token
    self.password_reset_sent_at = Time.current
    save!
    UserMailer.password_reset(self).deliver_now
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

  private
    def default_values
      self.roles ||= ["user"]
      self.status ||= :created
      self.account_type ||= User.account_types[:free_account]
    end

    def generate_token
      begin
        self.password_reset_token = SecureRandom.urlsafe_base64
      end while User.exists?(["settings -> 'password_reset_token' = '#{self.settings['password_reset_token']}'"])
    end
end
