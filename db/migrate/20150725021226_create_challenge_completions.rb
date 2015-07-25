class CreateChallengeCompletions < ActiveRecord::Migration
  def change
    create_table :challenge_completions do |t|
      t.references :user, index: true
      t.references :challenge, index: true

      t.timestamps null: false
    end
    add_foreign_key :challenge_completions, :users
    add_foreign_key :challenge_completions, :challenges
  end
end
