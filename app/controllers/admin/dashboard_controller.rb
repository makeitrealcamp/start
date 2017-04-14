class Admin::DashboardController < ApplicationController
before_action :admin_access

  def index
    @activity = ActivityLog.order('created_at DESC').limit(100)
    @top_active_users = User.where(status: User.statuses[:active]).order('current_points DESC')
    @top_users_current_month = top_users_current_month
    @solutions_stuck = Solution.failed.where("updated_at > ?", 20.days.ago).order('attempts DESC').limit(40)
  end

  private
    def top_users_current_month
      date_range = (Time.current.beginning_of_month..Time.current.end_of_month)

      # this returns a hash with user_id and points tuples
      user_points = Point.where(created_at: date_range).group(:user_id).sum(:points)

      data = user_points.keys.inject([]) do |elems, user_id|
        elems.push(user: User.find(user_id), points: user_points[user_id])
      end

      data.sort_by{ |hsh| hsh[:points] }.reverse
    end
end
