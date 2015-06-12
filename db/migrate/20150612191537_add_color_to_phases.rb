class AddColorToPhases < ActiveRecord::Migration
  def change
    add_column :phases, :color, :string
  end
end
