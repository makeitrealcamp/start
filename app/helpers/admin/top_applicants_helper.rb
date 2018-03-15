module Admin::TopApplicantsHelper
  def status_to_human(status)
    mappings = {
      applied: "aplicó",
      test_sent: "prueba enviada",
      test_received: "prueba recibida",
      test_graded: "prueba calificada",
      first_interview_scheduled: "primera entrevista",
      second_interview_held: "segunda entrevista",
      accepted: "aceptado",
      enrolled: "matriculado",
      not_enrolled: "no matriculado",
      rejected: "rechazado"
    }

    mappings[status.to_sym]
  end

  def generate_activity_detail(activity)
    str = "#{activity.user.first_name} #{activity.user.last_name} "

    if activity.type == "ChangeStatusApplicantActivity"
      str += "<strong>cambió el estado</strong> a <strong>#{status_to_human(activity.to_status)}</strong>"
    elsif activity.type == "EmailApplicantActivity"
      str += "<strong>envió un correo</strong> con asunto <strong>#{activity.subject}</strong>"
    elsif activity.type == "NoteApplicantActivity"
      str += "<strong>dejó la siguiente nota</strong>"
    end

    str.html_safe
  end

  def applicant_status_options
    TopApplicant.statuses.keys.inject([]) { |memo, s| memo << [status_to_human(s).capitalize, s] }
  end
end
