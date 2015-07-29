class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.references :user
      t.references :course, index: true
      t.integer :points

      t.timestamps null: false
    end
    add_foreign_key :points, :courses
  end
end
