class CreateQuizAttempts < ActiveRecord::Migration
  def change
    create_table :quiz_attempts do |t|
      t.references :user, index: true
      t.references :quiz, index: true

      t.timestamps null: false
    end
    add_foreign_key :quiz_attempts, :users
    add_foreign_key :quiz_attempts, :quizzes
  end
end
