class RequirePointsToRequiredPointsInBadges < ActiveRecord::Migration
  def change
    rename_column :badges, :require_points, :required_points
  end
end
