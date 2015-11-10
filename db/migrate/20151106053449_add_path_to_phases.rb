class AddPathToPhases < ActiveRecord::Migration
  def change
    add_reference :phases, :path, index: true
    add_foreign_key :phases, :paths
  end
end
