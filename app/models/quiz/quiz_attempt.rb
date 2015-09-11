# == Schema Information
#
# Table name: quiz_attempts
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  quiz_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_quiz_attempts_on_quiz_id  (quiz_id)
#  index_quiz_attempts_on_user_id  (user_id)
#

class Quiz::QuizAttempt < ActiveRecord::Base
  belongs_to :user
  belongs_to :quiz
  has_many :question_attempts
  has_many :questions, through: :question_attempts
end
