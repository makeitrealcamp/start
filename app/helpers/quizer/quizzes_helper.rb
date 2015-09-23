module Quizer
  module QuizzesHelper
    def question_attempt_path(question_attempt)
      course_quizer_quiz_quiz_attempt_question_attempt_path(
        question_attempt.quiz_attempt.quiz.course,
        question_attempt.quiz_attempt.quiz,
        question_attempt.quiz_attempt,
        question_attempt
      )
    end
  end
end
