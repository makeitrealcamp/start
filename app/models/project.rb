# == Schema Information
#
# Table name: projects
#
#  id                    :integer          not null, primary key
#  course_id             :integer
#  name                  :string
#  explanation_text      :text
#  explanation_video_url :string
#  published             :boolean
#  row                   :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  difficulty_bonus      :integer          default(0)
#
# Indexes
#
#  index_projects_on_course_id  (course_id)
#

class Project < ActiveRecord::Base
  include RankedModel
  ranks :row, with_same: :course_id

  validates :name, presence: true
  validates :explanation_text, presence: true
  validates :course, presence: true

  belongs_to :course
  has_many :project_solutions
  has_many :points, as: :pointable

  scope :for, -> user { published unless user.is_admin? }
  scope :published, -> { where(published: true) }

  BASE_POINTS = 500

  def point_value
    self.difficulty_bonus + Project::BASE_POINTS
  end
end
