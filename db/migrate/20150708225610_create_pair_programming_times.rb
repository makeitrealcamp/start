class CreatePairProgrammingTimes < ActiveRecord::Migration
  def change
    create_table :pair_programming_times do |t|
      t.references :user, index: true
      t.integer :day
      t.integer :start_time_hour
      t.integer :start_time_minute
      t.integer :end_time_hour
      t.integer :end_time_minute
      t.string :time_zone

      t.timestamps null: false
    end
    add_foreign_key :pair_programming_times, :users
  end
end
