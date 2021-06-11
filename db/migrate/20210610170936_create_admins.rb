class CreateAdmins < ActiveRecord::Migration[5.2]
  def change
    create_table :admins do |t|
      t.string :email, limit: 100
      t.string :password_digest
      t.text :permissions, array: true, default: []

      t.timestamps
    end
  end
end
