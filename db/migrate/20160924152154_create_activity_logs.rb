class CreateActivityLogs < ActiveRecord::Migration
  def change
    create_table :activity_logs do |t|
      t.references :user, index: true
      t.references :activity, polymorphic: true, index: true
      t.string :name
      t.text :description

      t.timestamps null: false
    end
    add_foreign_key :activity_logs, :users
  end
end
