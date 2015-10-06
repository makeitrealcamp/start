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
  factory :multi_answer_question, class: Quizer::MultiAnswerQuestion do
    quiz { create(:quiz) }
    data do
      {
        "text" => "What?",
        "wrong_answers" => [ "wrong answer a","wrong answer b","wrong answer c" ],
        "correct_answers" => [ "correct answer d","correct answer e" ]
      }
    end
  end

end
