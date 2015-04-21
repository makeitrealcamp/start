class CreateDiscussions < ActiveRecord::Migration
  def change
    create_table :discussions do |t|
      t.references :challenge, index: true
      t.string :title

      t.timestamps null: false
    end
    add_foreign_key :discussions, :challenges
  end
end
