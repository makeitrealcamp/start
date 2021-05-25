module Admin::TopApplicantsHelper
  def payment_method_to_human(payment_method)
    if payment_method == "scheme-1"
      "Esquema 1 - $0 de entrada + 17% ingresos (2 años)"
    elsif payment_method == "scheme-2"
      "Esquema 2 - $6M de entrada + 17% ingresos (1 años)"
    elsif payment_method == "scheme-3"
      "Esquema 3 - $12M de entrada"
    else
      "Sin definir"
    end
  end

  def format_to_human(format)
    if format == "format-full"
      "Tiempo completo"
    elsif format == "format-partial"
      "Tiempo parcial"
    else
      "Sin definir"
    end
  end

  def generate_activity_detail(activity)
    str = if activity.user
      "#{activity.user.first_name} #{activity.user.last_name} "
    else
      "La plataforma "
    end

    if activity.type == "ChangeStatusApplicantActivity"
      str += "<strong>cambió el estado</strong> a <strong>#{activity.applicant.class.status_to_human(activity.to_status)}</strong>"
    elsif activity.type == "EmailApplicantActivity"
      str += "<strong>envió un correo</strong> con asunto <strong>#{activity.subject}</strong>"
    elsif activity.type == "NoteApplicantActivity"
      str += "<strong>dejó la siguiente nota</strong>"
    end

    str.html_safe
  end

  def applicant_status_options(applicant)
    applicant.class.statuses.keys.inject([]) do |memo, s|
      memo << [applicant.class.status_to_human(s).capitalize, s]
    end
  end
end
