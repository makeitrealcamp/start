class CreateBillingCoupons < ActiveRecord::Migration
  def change
    create_table :billing_coupons do |t|
      t.string :name, limit: 30
      t.decimal :discount
      t.datetime :expires_at, null: false

      t.timestamps null: false
    end
  end
end
