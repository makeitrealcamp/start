class CreatePathSubscription < ActiveRecord::Migration
  def change
    create_table :path_subscriptions do |t|
      t.references :path, index: true
      t.references :user, index: true
    end
    add_foreign_key :path_subscriptions, :paths
    add_foreign_key :path_subscriptions, :users
  end
end
