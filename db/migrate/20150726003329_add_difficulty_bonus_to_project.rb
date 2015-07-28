class AddDifficultyBonusToProject < ActiveRecord::Migration
  def change
    add_column :projects, :difficulty_bonus, :integer, default: 0
  end
end
