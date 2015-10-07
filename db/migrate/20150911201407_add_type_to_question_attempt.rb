class AddTypeToQuestionAttempt < ActiveRecord::Migration
  def change
    add_column :question_attempts, :type, :string
  end
end
