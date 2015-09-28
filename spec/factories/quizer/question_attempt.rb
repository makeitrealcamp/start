
FactoryGirl.define do
  factory :question_attempt, class: Quizer::MultiAnswerQuestionAttempt do
    quiz_attempt { create(:quiz_attempt) }
    question { create(:multi_answer_question,quiz: self.quiz_attempt.quiz) }
    data do
      {
        "answers" => self.question.data["correct_answers"]
      }
    end
    factory :multi_answer_question_attempt do
    end
  end

end
