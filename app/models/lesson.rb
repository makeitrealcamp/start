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
#  free_preview :boolean          default(FALSE)
#  info         :text
#

class Lesson < ActiveRecord::Base
  include RankedModel
  ranks :row, with_same: :section_id

  belongs_to :section
  has_many :comments, as: :commentable
  has_many :lesson_completions, dependent: :delete_all

  validates :name, presence: true
  validates :video_url, presence: true
  validates :video_url, format: { with: URI.regexp }, if: :video_url?

  scope :published, -> { where(section_id: Resource.published.map(&:sections).flatten.map(&:id)) }
  default_scope { rank(:row) }

  def resource
    self.section.resource
  end

  def to_s
    name
  end

  def next(user)
    if user.has_access_to?(self.resource)
      self.section.lessons.where('row > ?', self.row).first
    else
      self.section.lessons.where('row > ? AND free_preview = ?', self.row, true).first
    end
  end
end
