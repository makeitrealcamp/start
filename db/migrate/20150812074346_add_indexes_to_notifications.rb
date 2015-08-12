class AddIndexesToNotifications < ActiveRecord::Migration
  def change
    add_index :notifications, :created_at
    add_index :notifications, :status
  end
end
