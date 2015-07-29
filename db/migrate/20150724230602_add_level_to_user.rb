class AddLevelToUser < ActiveRecord::Migration
  def change
    add_reference :users, :level, index: true
    add_foreign_key :users, :levels
  end
end
