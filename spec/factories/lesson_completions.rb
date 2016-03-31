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

FactoryGirl.define do
  factory :lesson_completion do
    user
    lesson
  end

end
