class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.references :user, index: true
      t.references :challenge, index: true
      t.integer :status
      t.integer :attempts, default: 0

      t.timestamps null: false
    end
    add_foreign_key :solutions, :users
    add_foreign_key :solutions, :challenges
  end
end
