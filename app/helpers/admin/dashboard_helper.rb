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

  def progress_data_past_months
    data = 6.downto(0).map do |i|
      range = i.months.ago.beginning_of_month..i.months.ago.end_of_month
      {
        month: l(i.months.ago, format: "%B"),
        points: Point.where(created_at: range).sum(:points)
      }
    end

    data.to_json.html_safe
  end

  def accumulated_by_day(range)
    Point.accumulated_by_day(range)
  end

  def current_month_range
    now = Time.zone.now
    now.beginning_of_month..now.end_of_day
  end

  def past_month_range
    m = 1.month.ago
    m.beginning_of_month..m.end_of_month
  end

  def format_day(data)
    data.map do |tx|
      tx[:date] = l(tx[:date], format: "%d")
    end
    data.to_json.html_safe
  end
end
