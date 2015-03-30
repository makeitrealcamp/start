class AddPropertiesToSolutions < ActiveRecord::Migration
  def change
    add_column :solutions, :properties, :hstore
    add_index :solutions, [:properties], name: "solutions_gin_properties", using: :gin

    rename_column :solutions, :completed_at, :completed_at2
    rename_column :solutions, :error_message, :error_message2

    reversible do |dir|
      dir.up do
        Solution.all.each do |solution|
          if solution.completed_at2
            solution.completed_at = solution.completed_at2
          end
          if solution.error_message2
            solution.error_message = solution.error_message2
          end
          solution.save!
        end
      end
    end
  end
end
