class AddPasswordAndAccessToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_digest, :string
    add_column :users, :access_type, :integer, default: 0
  end
end
