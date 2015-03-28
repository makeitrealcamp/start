class AddColumnsToSolutions < ActiveRecord::Migration
  def change
    add_column :solutions, :attempts, :integer
    add_column :solutions, :error_message, :string
    add_column :solutions, :completed_at, :datetime

    reversible do |dir|
      dir.up do
        Solution.update_all(attempts: 1)
        Solution.completed.each do |solution|
          solution.update(completed_at: solution.updated_at)
        end
      end
    end
  end
end
