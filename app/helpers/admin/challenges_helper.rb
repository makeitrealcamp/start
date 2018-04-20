module Admin::ChallengesHelper
  def percentage(challenge)
    if challenge.solutions.where("attempts = 1").count == 0
      percentage = challenge.solutions.where("attempts = 1").count
    else
      percentage = (challenge.solutions.where("status > 0").count*100)/challenge.solutions.where("attempts = 1").count
    end
      if percentage < 80
        concat content_tag(:span, "#{percentage}% (#{challenge.solutions.where("status > 0").count})", class: "challenge-effectiveness-red")
      else
        concat content_tag(:span, "#{percentage}% (#{challenge.solutions.where("status > 0").count})", class: "challenge-effectiveness")
      end
      nil
  end


  def attempts(challenge)
    if challenge.solutions.average("attempts") > 5.0
      concat content_tag(:span, challenge.solutions.average("attempts"), class: "challenge-average-red")
    else
      concat content_tag(:span, challenge.solutions.average("attempts"), class: "challenge-average")
    end
    nil
  end
end
