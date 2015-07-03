# == Schema Information
#
# Table name: lessons
#
#  id             :integer          not null, primary key
#  section_id     :integer
#  name           :string
#  video_url      :string
#  description    :text
#  row            :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  free_preview   :boolean          default(FALSE)
#  info           :text
#  video_duration :string
#
# Indexes
#
#  index_lessons_on_section_id  (section_id)
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
  scope :free_preview, -> { where(free_preview: true) }

  def self.for(user)
    if user.is_admin?
      all
    elsif user.paid_account?
      published
    else
      free_preview.published
    end
  end

  default_scope { rank(:row) }

  def resource
    self.section.resource
  end

  def to_s
    name
  end

  def next(user)
    lesson = self.section.lessons.for(user).where('row > ?', self.row).first
    if lesson.nil?
      section = self.section
      loop do
        section = section.next(user)
        break if section.nil? || !section.lessons.blank?
      end
      lesson = section.lessons.for(user).first unless section.nil?
    end

    lesson
  end
end
