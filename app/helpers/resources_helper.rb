module ResourcesHelper

  def types_resources
    [["External URL", "ExternalUrl"], ["Markdown Document", "MarkdownDocument"], ["Course", "Course"], ["Quiz", "Quizer::Quiz"]]
  end

  def resource_categories
    Resource.categories.keys.map do |category|
      [ I18n.t("resources.categories.#{category.to_s}"),category]
    end
  end

  def video_duration(lesson)
    "#{lesson.video_duration}" if lesson.video_duration?
  end

  def question_attempt_path(question_attempt)
    subject_resource_quiz_attempt_question_attempt_path(
      question_attempt.quiz_attempt.quiz.subject,
      question_attempt.quiz_attempt.quiz,
      question_attempt.quiz_attempt,
      question_attempt
    )
  end

  def finish_quiz_attempt_path(quiz_attempt)
    finish_subject_resource_quiz_attempt_path(
      quiz_attempt.quiz.subject,
      quiz_attempt.quiz,
      quiz_attempt
    )
  end

  def quiz_attempt_results_path(quiz_attempt)
    results_subject_resource_quiz_attempt_path(
      quiz_attempt.quiz.subject,
      quiz_attempt.quiz,
      quiz_attempt
    )
  end

  def ongoing_quiz_attempt_for_user_path(quiz,current_user)
    quiz_attempt = current_user.quiz_attempts.ongoing.find_by_quiz_id(quiz.id)
    subject_resource_quiz_attempt_path(
      quiz.subject,
      quiz,
      quiz_attempt
    )
  end
end
