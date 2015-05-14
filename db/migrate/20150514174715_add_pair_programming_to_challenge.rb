class AddPairProgrammingToChallenge < ActiveRecord::Migration
  def change
    add_column :challenges, :pair_programming, :boolean, default: false
  end
end
