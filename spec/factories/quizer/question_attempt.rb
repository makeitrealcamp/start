FactoryGirl.define do
  factory :question_attempt, class: Quizer::MultiAnswerQuestionAttempt do
    quiz_attempt { create(:quiz_attempt) }
    question { create(:multi_answer_question, quiz: self.quiz_attempt.quiz) }
    data do
      {
        "answers" => self.question.data["correct_answers"]
      }
    end
    factory :multi_answer_question_attempt do
    end
  end

  factory :open_question_attempt, class: Quizer::OpenQuestionAttempt do
    quiz_attempt { create(:quiz_attempt) }
    question { create(:open_question, quiz: self.quiz_attempt.quiz) }
    data do
      {
        "answer" => self.question.correct_answer
      }
    end
  end

  factory :single_answer_question_attempt, class: Quizer::SingleAnswerQuestionAttempt do
    quiz_attempt { create(:quiz_attempt) }
    question { create(:single_answer_question, quiz: self.quiz_attempt.quiz) }
    data do
      {
        "answer" => self.question.answer
      }
    end
  end

end
