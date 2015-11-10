class CreatePaths < ActiveRecord::Migration
  def change
    create_table :paths do |t|
      t.string :name
      t.string :description

      t.timestamps null: false
    end
  end
end
