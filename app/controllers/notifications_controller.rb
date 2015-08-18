class NotificationsController < ApplicationController
  before_action :private_access

  def show
    @notification = Notification.find(params[:id])
    owner_or_admin_access(@notification)
    @unread_count = current_user.notifications.unread.count

  end

  def index
    @user = current_user
    @page = params[:page] || 1
  end

  def mark_as_read
    current_user.notifications.unread.update_all(status: Notification.statuses[:read])
  end

end
