class AddPathToUser < ActiveRecord::Migration
  def change
    add_reference :users, :path, index: true
    add_foreign_key :users, :paths
  end
end
