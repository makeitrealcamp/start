class AddProfileToUsers < ActiveRecord::Migration
  def change
    add_column :users, :profile, :hstore
  end
end
