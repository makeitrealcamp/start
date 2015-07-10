class AddDurationAndRemoveEndTimeToPairProgrammingTimes < ActiveRecord::Migration
  def change
    remove_column :pair_programming_times, :end_time_hour, :integer
    remove_column :pair_programming_times, :end_time_minute, :integer
    add_column :pair_programming_times, :duration_in_minutes, :integer
  end
end
