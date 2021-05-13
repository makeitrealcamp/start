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

end
