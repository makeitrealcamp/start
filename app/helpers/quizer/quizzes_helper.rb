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

    def ongoing_quiz_attempt_for_user_path(quiz,current_user)
      quiz_attempt = current_user.quiz_attempts.ongoing.find_by_quiz_id(quiz.id)
      course_quizer_quiz_quiz_attempt_path(
        quiz.course,
        quiz,
        quiz_attempt
      )
    end
  end
end
