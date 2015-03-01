class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, limit: 100
      t.string :roles, array: true
      t.string :password_digest
      t.string :first_name, limit: 50
      t.string :last_name, limit: 50
      t.date :birthday
      t.string :phone, limit: 15

      t.timestamps null: false
    end
  end
end
