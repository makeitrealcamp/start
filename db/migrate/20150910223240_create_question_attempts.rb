class CreateQuestionAttempts < ActiveRecord::Migration
  def change
    create_table :question_attempts do |t|
      t.references :quiz_attempt, index: true
      t.references :question, index: true
      t.json :data

      t.timestamps null: false
    end
    add_foreign_key :question_attempts,:questions
    add_foreign_key :question_attempts,:quiz_attempts

  end
end
