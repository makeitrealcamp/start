# == Schema Information
#
# Table name: questions
#
#  id          :integer          not null, primary key
#  quiz_id     :integer
#  type        :string
#  data        :json
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  published   :boolean
#  explanation :text
#
# Indexes
#
#  index_questions_on_quiz_id  (quiz_id)
#

FactoryGirl.define do
  factory :multi_answer_question, class: Quizer::MultiAnswerQuestion do
    quiz { create(:quiz) }
    published true
    data do
      {
        "text" => "What?",
        "wrong_answers" => ["wrong answer a", "wrong answer b", "wrong answer c"],
        "correct_answers" => ["correct answer d", "correct answer e"]
      }
    end
  end

  factory :open_question, class: Quizer::OpenQuestion do
    quiz { create(:quiz) }
    published true
    data do
      {
        "text" => "5 + 5 ?",
        "correct_answer" => "10"
      }
    end
  end

  factory :single_answer_question, class: Quizer::SingleAnswerQuestion do
    quiz { create(:quiz) }
    published true
    data do
      {
        "text" => "5 + 5 ?",
        "answer" => "10",
        "wrong_answers" => ["20", "30", "5"],
      }
    end
  end

  factory :boolean_question, class: Quizer::BooleanQuestion do
    quiz { create(:quiz) }
    published true
    data do
      {
        "text" => "Earth is flat?",
        "correct_answer" => true
      }
    end
  end

end
