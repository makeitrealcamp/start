class RemoveRolesFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :roles, :string, limit: 100
  end
end
