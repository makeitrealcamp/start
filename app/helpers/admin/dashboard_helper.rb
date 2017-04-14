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
    data = (7).downto(1).map do |n| 
      {
        month: l((Time.now + 1.month) - n.month, format: "%B").titleize, 
        points: Point.where(created_at: (Time.now.beginning_of_month + 1.month) - n.month..(Time.now.end_of_month + 1.month) - n.month).sum(:points)
      }
    end

    "[" + data.map do |data|
      "{ y: #{data[:points]}, label: '#{data[:month]}'}"
    end.join(",") + "]"
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
