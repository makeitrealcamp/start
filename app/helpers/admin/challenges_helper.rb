module Admin::ChallengesHelper
  def challenge_effectiveness(challenge)
    completed = challenge.solutions.where(status: Solution.statuses[:completed]).count
    attempted = challenge.solutions.where("attempts > ?", 1).count

    percentage = attempted > 0 ? (completed / attempted.to_f) * 100 : 0
    content_tag :span, "#{number_to_percentage(percentage, precision: 0)} (#{completed})",
        class: percentage < 80 ? "critical" : ""
  end


  def challenge_attempts_average(challenge)
    value = challenge.solutions.average(:attempts)
    value = 0 if value.nil?

    content_tag :span, "#{number_with_precision(value, precision: 1, locale: :en)}",
        class: value > 5 ? "critical" : ""
  end
end
