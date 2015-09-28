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

    def finish_quiz_attempt_path(quiz_attempt)
      finish_course_quizer_quiz_quiz_attempt_path(
        quiz_attempt.quiz.course,
        quiz_attempt.quiz,
        quiz_attempt
      )
    end

    def quiz_attempt_results_path(quiz_attempt)
      results_course_quizer_quiz_quiz_attempt_path(
        quiz_attempt.quiz.course,
        quiz_attempt.quiz,
        quiz_attempt
      )
    end
  end
end
