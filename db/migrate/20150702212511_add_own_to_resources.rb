class AddOwnToResources < ActiveRecord::Migration
  def change
    add_column :resources, :own, :boolean
  end
end
