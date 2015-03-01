class ChangeColumnLengthInCourses < ActiveRecord::Migration
  def change
    change_column :courses, :name, :string, limit: 50
  end
end
