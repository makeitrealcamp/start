# == Schema Information
#
# Table name: projects
#
#  id                    :integer          not null, primary key
#  subject_id            :integer
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
#  index_projects_on_subject_id  (subject_id)
#

class Project < ApplicationRecord
  include RankedModel
  ranks :row, with_same: :subject_id

  validates :name, presence: true
  validates :explanation_text, presence: true
  validates :subject, presence: true

  belongs_to :subject
  has_many :project_solutions
  has_many :points, as: :pointable

  scope :for, -> user { published unless user.is_admin? }
  scope :published, -> { where(published: true) }

  BASE_POINTS = 500

  def point_value
    self.difficulty_bonus + Project::BASE_POINTS
  end

  def to_s
    name
  end

  def to_path
    "#{subject.to_path}/projects/#{id}"
  end

  def to_html_link
    "<a href='#{to_path}'>#{to_s}</a>"
  end

  def to_html_description
    "el proyecto #{to_html_link} del tema #{subject.to_html_link}"
  end
end
