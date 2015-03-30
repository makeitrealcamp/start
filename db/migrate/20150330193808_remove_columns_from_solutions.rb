class RemoveColumnsFromSolutions < ActiveRecord::Migration
  def change
    remove_column :solutions, :completed_at2, :datetime
    remove_column :solutions, :error_message2, :string
  end
end
