class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user, index: true
      t.text :message
      t.integer :status

      t.timestamps null: false
    end
    add_foreign_key :notifications, :users
  end
end
