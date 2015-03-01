class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name, limit: 20
      t.integer :row
      t.text :abstract

      t.timestamps null: false
    end
  end
end
