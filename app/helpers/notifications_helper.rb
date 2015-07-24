module NotificationsHelper
  def notifications_class(user)
    count = user.notifications.count
    "btn-danger" if count > 0
    "btn-default" if count == 0
  end
end
