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

  def quiz_summary(quiz)
    summary = "<p>Este quiz es de <strong>#{quiz.questions.published.count} preguntas</strong> y lo puedes intentar las veces que lo desees."

    num_finished_attempts = quiz.num_finished_attempts(current_user)
    if num_finished_attempts > 0
      last_attempt = quiz.last_attempt(current_user)
      summary += " Tu último intento fue hace <strong>#{distance_of_time_in_words(Time.current, last_attempt.updated_at)}</strong> y tu puntaje fue <strong>#{number_to_percentage(last_attempt.score * 100, precision: 0)}</strong>. #{link_to 'Ver resultados', quiz_attempt_results_path(last_attempt)}.</p>"
    end

    if quiz.is_being_attempted_by_user?(current_user)
      current_attempt = quiz.current_attempt(current_user)
      summary += "<p>Actualmente estás intentando este quiz. Lo comenzaste <strong>hace #{distance_of_time_in_words(Time.current, current_attempt.created_at)}</strong> y vas en la <strong>pregunta número #{current_attempt.current_question + 1}</strong>."
    elsif num_finished_attempts > 0
      summary += "<p>¿Deseas intentarlo nuevamente?</p>"
    end

    unless quiz.is_or_has_been_attempted_by_user?(current_user)
      summary += " Aún no lo has intentado pero este sería un excelente momento para hacerlo :)</p>"
      summary += "<p>¿Te atreves a iniciarlo?</p>"
    end

    summary += "</p>" unless summary.end_with?("</p>")
    summary
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

  def ongoing_quiz_attempt_for_user_path(quiz, current_user)
    quiz_attempt = current_user.quiz_attempts.ongoing.find_by_quiz_id(quiz.id)
    next_subject_resource_quiz_attempt_question_attempts_path(
      quiz.subject,
      quiz,
      quiz_attempt
    )
  end

  def reset_quiz_attempt_for_user_path(quiz, current_user)
    quiz_attempt = current_user.quiz_attempts.ongoing.find_by_quiz_id(quiz.id)
    subject_resource_quiz_attempt_path(
      quiz.subject,
      quiz,
      quiz_attempt
    )
  end
end
