class CreateQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
      t.string :name
      t.integer :row
      t.string :slug
      t.references :course, index: true

      t.timestamps null: false
    end
    add_foreign_key :quizzes, :courses
  end
end
