class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.references :folder, polymorphic: true, index: true
      t.string :name, limit: 50
      t.text :content

      t.timestamps null: false
    end
  end
end
