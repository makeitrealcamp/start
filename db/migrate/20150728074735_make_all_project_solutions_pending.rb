class MakeAllProjectSolutionsPending < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        ProjectSolution.update_all(status: ProjectSolution.statuses[:pending_review])
      end
    end
  end
end
