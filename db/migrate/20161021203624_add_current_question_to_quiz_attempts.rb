class AddCurrentQuestionToQuizAttempts < ActiveRecord::Migration
  def change
    add_column :quiz_attempts, :current_question, :integer, default: 0
  end
end
