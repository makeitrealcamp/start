class NotificationsController < ApplicationController
  before_action :private_access

  def index
    last_created_at = Time.strptime(params[:last_created_at],"%Q") + (0.5).second
    @notifications = current_user.notifications.where("created_at > ?",last_created_at)
    # Avoid count in DB
    unless @notifications.empty?
      @unread_count = current_user.notifications.unread.count
    end
  end

  def mark_as_read
    current_user.notifications.unread.update_all(status: Notification.statuses[:read])
  end

end
