module Admin::TopApplicantsHelper
  def payment_method_to_human(payment_method, format, country)
    countries = {
      MX: {
        code: "MX",
        country: "México",
        currency: "MXN",
        scheme2Cost: "$42,500",
        scheme3Cost: "$85,000",
        scheme4Cost: "$85,000",
        scheme5Cost: "$85,000"
      },
      CO: {
        code: "CO",
        country: "Colombia",
        currency: "COP",
        culturePayment: '$50,000',
        scheme2Cost: "$7.5M",
        scheme3Cost: "$19.5M",
        scheme4Cost: "$19.5M",
        scheme5Cost: "$19.5M"
      },
      PE: {
        code: "PE",
        country: "Perú",
        currency: "PEN",
        scheme2Cost: "S/ 6,750",
        scheme3Cost: "S/ 18,750",
        scheme4Cost: "S/ 18,750",
        scheme5Cost: "S/ 18,750"
      },
      CR: {
        code: "CR",
        country: "Costa Rica",
        currency: "CRC",
        scheme2Cost: "₡ 1,152,000",
        scheme3Cost: "₡ 3,200,000",
        scheme4Cost: "₡ 3,200,000",
        scheme5Cost: "₡ 3,200,000"
      },
      CL: {
        code: "CL",
        country: "Chile",
        currency: "CLP",
        scheme2Cost: "$ 1,438,200",
        scheme3Cost: "$ 3,995,000",
        scheme4Cost: "$ 3,995,000",
        scheme5Cost: "$ 3,995,000"
      },
      other: {
        country: "",
        currency: "usd",
        scheme2Cost: "$2,500",
        scheme3Cost: "$5,000",
        scheme4Cost: "$5,000",
        scheme5Cost: "$5,000"
      }
    }
    
    country = "other" unless ["CO", "MX", "PE", "CL", "CR"].include?(country)

    country = countries[country.to_sym]

    if payment_method == "scheme-3" && format == "full"
      "Pagar el total de #{country[:scheme3Cost]} #{country[:currency]} al inicio"  
    elsif payment_method == "scheme-2" && format == "full"
      "Pagar por cuotas (de 2 a 24 cuotas)"
    elsif payment_method == "scheme-1" && format == "full"
      "Pagar 0 #{country[:currency]} al inicio + 17% de tus ingresos al encontrar trabajo (durante 3 años)"
    elsif payment_method == "scheme-3" && format == "partial"
      "Pagar el total de #{country[:scheme5Cost]} #{country[:currency]} al inicio"
    elsif payment_method == "scheme-1" && format == "partial"
      "Pagar por cuotas (de 2 a 24 cuotas)"
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

  def applicant_rejected_reason_options(applicant)
    ChangeStatusApplicantActivity.rejected_reasons.keys.inject([]) do |memo, s|
      memo << [ChangeStatusApplicantActivity.rejected_reason_to_human(s).capitalize, s]
    end
  end
end
