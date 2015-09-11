
FactoryGirl.define do
  factory :multi_answer_question_attempt, class: Quiz::MultiAnswerQuestionAttempt do
    quiz_attempt { create(:quiz_attempt) }
    question { create(:multi_answer_question,quiz: self.quiz_attempt.quiz) }
    data do
      {
        "answers" => self.question.data["correct_answers"]
      }
    end
  end

end
