class AddCategoryToResources < ActiveRecord::Migration
  def change
    add_column :resources, :category, :integer
  end
end
