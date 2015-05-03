class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.references :resource, index: true
      t.string :title

      t.timestamps null: false
    end
  end
end
