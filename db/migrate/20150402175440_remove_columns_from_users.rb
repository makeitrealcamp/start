class RemoveColumnsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :first_name, :string, limit: 50
    remove_column :users, :last_name, :string, limit: 50
    remove_column :users, :birthday, :date
    remove_column :users, :phone, :string, limit: 15
  end
end
