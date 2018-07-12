# == Schema Information
#
# Table name: lesson_completions
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  lesson_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_lesson_completions_on_lesson_id  (lesson_id)
#  index_lesson_completions_on_user_id    (user_id)
#

class LessonCompletion < ApplicationRecord
  belongs_to :user
  belongs_to :lesson

  validates :user, presence: true
  validates :lesson, presence: true

  after_create :log_activity

  private
    def log_activity
      description = "Completó #{lesson.to_html_description}"
      ActivityLog.create(name: "completed-lesson", user: user, activity: self, description: description)
    end
end
