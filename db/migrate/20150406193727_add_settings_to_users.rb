class AddSettingsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :settings, :hstore
    remove_column :users, :password_reset_token, :string
    remove_column :users, :password_reset_sent_at, :datetime
  end
end
