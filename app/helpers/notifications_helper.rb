module NotificationsHelper
  def notifications_class(count)
    return "btn-danger" if count > 0
    return "btn-default" if count == 0
  end
end
