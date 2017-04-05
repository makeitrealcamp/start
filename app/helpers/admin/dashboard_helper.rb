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

  def progress_data_past_months(user)
    data = (7).downto(1).map do |n| 
      { 
        month: l((Time.now + 1.month) - n.month, format: "%B").titleize, 
        points: Point.where(created_at: (Time.now.beginning_of_month + 1.month) - n.month..(Time.now.end_of_month + 1.month) - n.month).sum(:points)
      }
    end

    "[" + data.map do |data|
      "{ y:#{data[:points]}, label: '#{data[:month]}'}"
    end.join(",") + "]"
  end

  def progress_data_actual_month(user)
    month_begin = Date.today.beginning_of_month
    month_end = Date.today.end_of_month+1
    points_month = Point.where(created_at: month_begin..month_end).order('created_at')

    data = (Date.today.beginning_of_month..Date.today.end_of_month).map do |day|
      {
        points: 0,
        date: day
      }
    end

    count = 0
    points_month.each do |point|
      while point.created_at.day != data[count][:date].day
        count+=1 
      end
      data[count][:points] += point.points
    end
    
    sum = 0
    "[" + data.map do |data|
      "{ x: new Date(#{data[:date].year}, #{data[:date].month-1}, #{data[:date].day}), y: #{sum += data[:points]}}"
    end.join(",") + "]"
  end

  def most_active_user_month(users)
    month_begin = Date.today.beginning_of_month
    month_end = Date.today.end_of_month+1
    data = users.map do |user|
      {user: user, month_points: user.points.where(created_at: month_begin..month_end).sum(:points)}
    end
    data.sort_by!{ |hsh| hsh[:month_points] }.reverse
  end
end
