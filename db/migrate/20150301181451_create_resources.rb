class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.references :course, index: true
      t.string :title, limit: 100
      t.string :description
      t.integer :row
      t.integer :type
      t.string :url
      t.string :estimated, limit: 70

      t.timestamps null: false
    end
    add_foreign_key :resources, :courses
  end
end
