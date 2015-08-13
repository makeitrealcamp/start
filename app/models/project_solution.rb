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

  enum status: [:pending_review, :reviewed]
  after_initialize :default_values
  after_save :notify_mentors_if_pending_review

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

  def name_for_notification
    "Solución para #{self.project.name}"
  end

  def url_for_notification
    Rails.application.routes.url_helpers.course_project_project_solution_url(self.course,self.project, self)
  end

  private
    def default_values
      self.status ||= ProjectSolution.statuses[:pending_review]
    end

    def notify_mentors_if_pending_review
      if self.status == "pending_review" && self.status_was != "pending_review"
        notify_mentors
      end
    end
end
