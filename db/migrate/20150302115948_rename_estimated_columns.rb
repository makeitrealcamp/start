class RenameEstimatedColumns < ActiveRecord::Migration
  def change
    rename_column :courses, :estimated, :time_estimate
    rename_column :resources, :estimated, :time_estimate

    change_column :resources, :time_estimate, :string, limit: 50
  end
end
