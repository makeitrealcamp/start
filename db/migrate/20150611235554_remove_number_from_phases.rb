class RemoveNumberFromPhases < ActiveRecord::Migration
  def change
    remove_column :phases, :number
  end
end
