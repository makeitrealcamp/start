class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.references :course, index: true
      t.string :name, limit: 100
      t.text :instructions
      t.text :evaluation
      t.integer :row
      t.boolean :published

      t.timestamps null: false
    end
    add_foreign_key :challenges, :courses
  end
end
