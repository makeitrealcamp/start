class AddColumnsToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :excerpt, :string
    add_column :courses, :description, :string
  end
end
