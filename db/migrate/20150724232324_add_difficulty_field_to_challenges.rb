class AddDifficultyFieldToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :difficulty_bonus, :integer
  end
end
