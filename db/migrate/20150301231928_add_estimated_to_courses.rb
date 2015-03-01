class AddEstimatedToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :estimated, :string, limit: 50
  end
end
