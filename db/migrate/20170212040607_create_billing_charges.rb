class CreateBillingCharges < ActiveRecord::Migration
  def change
    create_table :billing_charges do |t|
      t.string :uid, limit: 50
      t.references :user, index: true
      t.integer :payment_method, default: 0
      t.integer :status, default: 0
      t.string :currency, limit: 5
      t.decimal :amount
      t.decimal :tax
      t.decimal :tax_percentage
      t.string :description
      t.hstore :details

      t.timestamps null: false
    end
    add_foreign_key :billing_charges, :users
  end
end
