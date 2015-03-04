class RemoveAttemptsFromSolutions < ActiveRecord::Migration
  def change
    remove_column :solutions, :attempts, :integer
  end
end
