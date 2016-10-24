module Quizer::QuizAttemptsHelper
  def quiz_score_class(quiz_attempt)
    quiz_attempt.score > 0.8 ? 'passed' : 'failed'
  end

  def quiz_time_class(quiz_attempt)
    time = (quiz_attempt.updated_at - quiz_attempt.created_at).to_i / 60
    expected_time = quiz_attempt.question_attempts.count

    time < expected_time ? 'passed' : 'failed'
  end
end
