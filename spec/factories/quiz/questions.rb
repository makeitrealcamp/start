# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  quiz_id    :integer
#  type       :string
#  data       :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_questions_on_quiz_id  (quiz_id)
#

FactoryGirl.define do
  factory :multi_answer_question, class: Quiz::MultiAnswerQuestion do
    quiz { create(:quiz) }
    data do
      {
        "question" => "What?",
        "wrong_answers" => [ "a","b","c" ],
        "correct_answers" => [ "d","e" ]
      }
    end
  end

end
