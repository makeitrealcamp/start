class RemoveUrlFromActivityLogs < ActiveRecord::Migration
  def change
    remove_column :activity_logs, :url, :string
  end
end
