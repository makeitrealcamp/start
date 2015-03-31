class AddIndexToResourcesUsers < ActiveRecord::Migration
  def change
    add_index :resources_users, [:resource_id, :user_id], unique: true
  end
end
