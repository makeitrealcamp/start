class AddTypeToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :notification_type, :integer
  end
end
