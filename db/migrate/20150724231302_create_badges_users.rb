class CreateBadgesUsers < ActiveRecord::Migration
  def change
    create_table :badges_users do |t|
      t.integer :user_id
      t.integer :badge_id

      t.timestamps null: false
    end
  end
end
