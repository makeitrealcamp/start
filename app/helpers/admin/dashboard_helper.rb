module Admin::DashboardHelper
  def num_total_users
    User.all.count
  end

  def num_active_users
    User.where('last_active_at > ?', Date.current - 7).count
  end

  def num_challenges_solved
    Solution.completed.count
  end

  def registered_users_data(start = 30.days.ago)
    (start.to_date..Date.today).map do |date|
      {
        label: date,
        y: User.where(created_at: date.beginning_of_day..date.end_of_day).count
      }
    end
  end

  def solved_challenges_data(start = 30.days.ago)
    (start.to_date..Date.today).map do |date|
      {
        label: date,
        y: Solution.completed.where(completed_at: date.beginning_of_day..date.end_of_day).count
      }
    end
  end
end
