class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.references :section, index: true
      t.string :name
      t.string :video_url
      t.text :description
      t.integer :row

      t.timestamps null: false
    end
    add_foreign_key :lessons, :sections
  end
end
