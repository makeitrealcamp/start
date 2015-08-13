class NotificationsController < ApplicationController
  before_action :private_access

  def index
    @user = current_user
    @page = params[:page] || 1
  end

  def retrieve_new
    @unread_count = current_user.notifications.unread.count

    if params[:last_created_at].blank?
      last_created_at = Time.now
    else
      last_created_at = Time.strptime(params[:last_created_at],"%Q") + (0.5).second
    end
    @notifications = current_user.notifications.where("created_at > ?",last_created_at)

  end

  def mark_as_read
    current_user.notifications.unread.update_all(status: Notification.statuses[:read])
  end

end
