class CreateLessonCompletions < ActiveRecord::Migration
  def change
    create_table :lesson_completions do |t|
      t.references :user, index: true
      t.references :lesson, index: true

      t.timestamps null: false
    end
    add_foreign_key :lesson_completions, :users
    add_foreign_key :lesson_completions, :lessons
  end
end
