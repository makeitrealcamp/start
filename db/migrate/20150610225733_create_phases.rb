class CreatePhases < ActiveRecord::Migration
  def change
    create_table :phases do |t|
      t.integer :number
      t.string :name
      t.text :description
      t.string :slug
      t.integer :row
      t.boolean :published

      t.timestamps null: false
    end
  end
end
