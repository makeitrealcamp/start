class AddSlugColumnToModels < ActiveRecord::Migration
  def change
    add_column :courses, :slug, :string, unique: true
    add_column :resources, :slug, :string, unique: true
    add_column :challenges, :slug, :string, unique: true
  end
end
