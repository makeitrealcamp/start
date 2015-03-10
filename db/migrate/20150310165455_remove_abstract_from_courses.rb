class RemoveAbstractFromCourses < ActiveRecord::Migration
  def change
    remove_column :courses, :abstract, :text
  end
end
