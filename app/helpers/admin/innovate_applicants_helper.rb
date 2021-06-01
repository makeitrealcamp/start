module Admin::InnovateApplicantsHelper
  def lang_to_human(lang)
    mappings = {
      javascript: "JavaScript",
      ruby: "Ruby",
      python: "Python",
      php: "PHP",
      java: "Java",
      cplus: "C++",
      csharp: "C#"
    }

    mappings[lang.to_sym]
  end

  def innovate_order_by_to_human(order_by)
    if order_by == "created_at"
      "Fecha de Aplicación"
    elsif order_by == "updated_at"
      "Última Actualización"
    else
      ""
    end
  end

end
