class RenameCoursesToSubjects < ActiveRecord::Migration
  def change
    rename_table :courses, :subjects

    rename_column :badges, :course_id, :subject_id
    rename_column :challenges, :course_id, :subject_id
    rename_column :course_phases, :course_id, :subject_id
    rename_column :points, :course_id, :subject_id
    rename_column :projects, :course_id, :subject_id
    rename_column :quizzes, :course_id, :subject_id
    rename_column :resources, :course_id, :subject_id
  end
end
