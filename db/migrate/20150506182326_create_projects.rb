class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.references :course, index: true
      t.string :name
      t.text :explanation_text
      t.string :explanation_video_url
      t.boolean :published
      t.integer :row
      t.timestamps null: false
    end
    add_foreign_key :projects, :courses
  end
end
