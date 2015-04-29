# == Schema Information
#
# Table name: lessons
#
#  id           :integer          not null, primary key
#  section_id   :integer
#  name         :string
#  video_url    :string
#  description  :text
#  row          :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  free_preview :boolean          default("false")
#

class Lesson < ActiveRecord::Base
  belongs_to :section
  has_many :comments, as: :commentable

  validates :name, presence: true
  validates :video_url, presence: true
  validates :video_url, format: { with: URI.regexp }, if: :video_url?

  def resource
    self.section.resource
  end
end
