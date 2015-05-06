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
#

class Project < ActiveRecord::Base

  validates :name, presence: true
  validates :explanation_text, presence: true
  validates :course, presence: true

  belongs_to :course
  has_many :comments, as: :commentable


  after_initialize :defaults

  scope :published, -> { where(published: true) }

  protected

  def defaults
    self.published ||= false
  end
end
