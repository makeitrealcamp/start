class CreateEnrollments < ActiveRecord::Migration
  def change
    create_table :enrollments do |t|
      t.references :user, index: true
      t.references :resource, index: true
      t.decimal :price
      t.datetime :valid_through

      t.timestamps null: false
    end
    add_foreign_key :enrollments, :users
    add_foreign_key :enrollments, :resources
  end
end
