module UsersHelper
  def name(user)
    n = user.active? ? "(#{user.first_name})" : ""
    "#{user.email} #{n}"
  end

  def user_solved_challenges_data(user, start = 30.days.ago)
    (start.to_date..Date.today).map do |date|
      {
        label: date,
        y: user.solutions.completed_at_after(date.beginning_of_day).completed_at_before(date.end_of_day).count
      }
    end
  end
end
