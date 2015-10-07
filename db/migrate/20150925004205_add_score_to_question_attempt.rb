class AddScoreToQuestionAttempt < ActiveRecord::Migration
  def change
    add_column :question_attempts, :score, :decimal
  end
end
