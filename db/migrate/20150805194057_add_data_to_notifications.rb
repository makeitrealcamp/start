class AddDataToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :data, :json
  end
end
