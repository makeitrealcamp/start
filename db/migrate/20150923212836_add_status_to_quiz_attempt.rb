class AddStatusToQuizAttempt < ActiveRecord::Migration
  def change
    add_column :quiz_attempts, :status, :integer
  end
end
