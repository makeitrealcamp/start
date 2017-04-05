class Admin::DashboardController < ApplicationController
before_action :admin_access

  def index
    @activity = ActivityLog.order('created_at DESC').limit(20)
    @users = User.limit(20)
    @solutions_stuck = Solution.failed.order('attempts DESC').limit(20)
  end
end
