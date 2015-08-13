class RemoveMessageFromNotifications < ActiveRecord::Migration
  def change
    remove_column :notifications, :message, :text
  end
end
