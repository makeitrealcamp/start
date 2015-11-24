class CreateCoursePhases < ActiveRecord::Migration
  def change
    create_table :course_phases do |t|
      t.references :course
      t.references :phase

      t.timestamps null: false
    end
  end
end
