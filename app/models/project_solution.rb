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
  enum status: [:pending_review, :reviewed]

  has_many :comments, as: :commentable

  validates :project, presence: true
  validates :user, presence: true
  validates :repository, presence: true
  validates :summary, presence: true
  after_save :request_revision

  def request_revision

  end

end
