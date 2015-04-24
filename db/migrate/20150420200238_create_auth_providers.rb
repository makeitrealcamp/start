class CreateAuthProviders < ActiveRecord::Migration
  def change
    create_table :auth_providers do |t|
      t.references :user, index: true
      t.string :provider
      t.string :uid
      t.string :image

      t.timestamps null: false
    end
    add_foreign_key :auth_providers, :users
  end
end
