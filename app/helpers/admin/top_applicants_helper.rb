module Admin::TopApplicantsHelper
  def payment_method_to_human(payment_method, format, country)
    countries = {
      MX: {
        currency: "MXN",
        scheme2Cost: "$42,500",
        scheme3Cost: "$85,000",
        scheme4InstallmentFee: "$3638",
        scheme4Installments: "8",
        scheme5InstallmentFee: "$17,000",
        scheme5Installments: "5",
      },
      CO: {
        currency: "COP",
        scheme2Cost: "$7.5M",
        scheme3Cost: "$15M",
        scheme4InstallmentFee: "$675.000",
        scheme4Installments: "8",
        scheme5InstallmentFee: "$3M",
        scheme5Installments: "5",
      },
      other: {
        currency: "usd",
        scheme2Cost: "$2,500",
        scheme3Cost: "$5,000",
        scheme4InstallmentFee: "$315",
        scheme4Installments: "8",
        scheme5InstallmentFee: "$1,000",
        scheme5Installments: "5",
      }
    }
    
    country = "other" if country != "CO" && country != "MX"
    country = countries[country.to_sym]

    if payment_method == "scheme-1" && format == "full"
      "Esquema 1 - $0 COP de entrada + 17% de ingresos (3 años)"
    elsif payment_method == "scheme-2" && format == "full"
      "Esquema 2 - #{country[:scheme2Cost]} #{country[:currency]} de entrada + 17% de ingresos (1 año y medio)"
    elsif payment_method == "scheme-3" && format == "full"
      "Esquema 3 - #{country[:scheme3Cost]} #{country[:currency]} de entrada"
    elsif payment_method == "scheme-1" && format == "partial"
      "Esquema 1 - #{country[:scheme4Installments]} pagos de #{country[:scheme4InstallmentFee]} #{country[:currency]} + 17% de ingresos (2 años)"
    elsif payment_method == "scheme-2" && format == "partial"
      "Esquema 2 - #{country[:scheme5Installments]} pagos de #{country[:scheme5InstallmentFee]} #{country[:currency]}"
    elsif payment_method == "scheme-3" && format == "partial"
      "Esquema 3 - #{country[:scheme3Cost]} #{country[:currency]} de entrada"
    else
      "Sin definir"
    end 
  end

  def format_to_human(format)
    if format == "full"
      "Tiempo completo"
    elsif format == "partial"
      "Tiempo parcial"
    else
      "Sin definir"
    end
  end
  
  def stipend_to_human(stipend)
    if stipend == "on"
      "Si"
    else
      "No"
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
