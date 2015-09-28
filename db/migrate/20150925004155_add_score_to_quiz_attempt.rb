class AddScoreToQuizAttempt < ActiveRecord::Migration
  def change
    add_column :quiz_attempts, :score, :decimal
  end
end
