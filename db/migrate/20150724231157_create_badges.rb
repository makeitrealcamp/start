class CreateBadges < ActiveRecord::Migration
  def change
    create_table :badges do |t|
      t.string :name
      t.text :description
      t.integer :require_points
      t.string :image_url
      t.integer :course_id

      t.timestamps null: false
    end
  end
end
