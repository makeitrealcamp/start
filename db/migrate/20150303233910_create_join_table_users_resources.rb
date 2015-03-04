class CreateJoinTableUsersResources < ActiveRecord::Migration
  def change
    create_join_table :users, :resources do |t|
      t.index [:user_id, :resource_id]
      t.index [:resource_id, :user_id]
    end
  end
end
