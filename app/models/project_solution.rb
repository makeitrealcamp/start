# == Schema Information
#
# Table name: project_solutions
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  project_id :integer
#  repository :string
#  url        :string
#  summary    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status     :integer
#
# Indexes
#
#  index_project_solutions_on_project_id  (project_id)
#  index_project_solutions_on_user_id     (user_id)
#

class ProjectSolution < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  has_many :comments, as: :commentable

  validates :project, presence: true
  validates :user, presence: true
  validates :repository, presence: true
  validates :summary, presence: true
  validates :url, format: { with: URI.regexp }, if: Proc.new { |a| a.url.present? }
  validate  :validate_repository

  enum status: [:pending_review, :reviewed]
  after_initialize :default_values
  after_save :notify_mentors_if_pending_review
  after_create :log_activity

  delegate :course, to: :project

  def point_value
    self.project.points.where(user: self.user).sum(:points)
  end

  def notify_mentors
    admins = User.admin_account.all
    admins.each do |admin|
      UserMailer.project_solution_notification(admin, self).deliver_now
    end
  end

  def to_s
    "solución al proyecto #{self.project.name}"
  end

  def to_path
    "#{project.to_path}"
  end

  def to_html_link
    "<a href='#{to_path}'>#{to_s}</a>"
  end

  def to_html_description
    "la #{to_html_link} del curso #{project.course.to_html_link}"
  end

  private
    def default_values
      self.status ||= ProjectSolution.statuses[:pending_review]
    end

    def validate_repository
      begin
        unless Octokit.repository?(repository)
          errors.add(:repository, "No se encontró el repositorio #{repository}")
        end
      rescue ArgumentError
        errors.add(:repository, "Formato invalido")
      end
    end

    def notify_mentors_if_pending_review
      if self.status == "pending_review" && self.status_was != "pending_review"
        notify_mentors
      end
    end

    def log_activity
      description = "Envió una solución a #{project.to_html_description}"
      ActivityLog.create(user: user, activity: self, description: description)
    end
end
