class AddStatusToProjectSolutions < ActiveRecord::Migration
  def change
    add_column :project_solutions, :status, :integer
  end
end
