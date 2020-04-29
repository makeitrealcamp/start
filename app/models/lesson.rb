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
#  free_preview   :boolean          default("false")
#  info           :text
#  video_duration :string
#
# Indexes
#
#  index_lessons_on_section_id  (section_id)
#

class Lesson < ApplicationRecord
  include RankedModel
  ranks :row, with_same: :section_id

  belongs_to :section
  has_many :comments, as: :commentable
  has_many :lesson_completions, dependent: :delete_all

  validates :name, presence: true
  validates :video_url, presence: true
  validates :video_url, format: { with: URI.regexp }, if: :video_url?

  scope :published, -> { where(section_id: Course.published.map(&:sections).flatten.map(&:id)) }
  scope :free_preview, -> { where(free_preview: true) }
  default_scope { rank(:row) }

  delegate :subject, :resource, to: :section

  def self.for(user)
    user.is_admin? ? all : published
  end

  def resource
    self.section.resource
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

  def to_s
    name
  end

  def to_path
    "#{section.to_path}/lessons/#{id}"
  end

  def to_html_link
    "<a href='#{to_path}'>#{name}</a>"
  end

  def to_html_description
    "la lección #{to_html_link} del curso #{resource.to_html_link} del tema #{resource.subject.to_html_link}"
  end
end
