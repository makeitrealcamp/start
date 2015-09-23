# == Schema Information
#
# Table name: quiz_quiz_attempts
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  quiz_quiz_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_quiz_quiz_attempts_on_quiz_quiz_id  (quiz_quiz_id)
#  index_quiz_quiz_attempts_on_user_id       (user_id)
#

FactoryGirl.define do
  factory :quiz_attempt, :class => Quizer::QuizAttempt do
    user { create(:user) }
    quiz { create(:quiz) }
  end

end
