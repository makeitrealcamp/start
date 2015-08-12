module NotificationsHelper
  def notifications_class(count)
    return "btn-danger" if count > 0
    return "btn-default" if count == 0
  end

  def last_created_at(notifications)
    if notifications.empty?
      created_at = DateTime.new
    else
      created_at = notifications.order('created_at DESC').first.created_at
    end
    created_at.to_datetime.strftime("%Q")
  end

end
