class CreateLevels < ActiveRecord::Migration
  def change
    create_table :levels do |t|
      t.string :name
      t.integer :required_points
      t.string :image_url

      t.timestamps null: false
    end
  end
end
