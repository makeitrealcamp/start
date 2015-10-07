class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.references :quiz, index: true
      t.string :type
      t.json :data

      t.timestamps null: false
    end
    add_foreign_key :questions,:quizzes
  end
end
