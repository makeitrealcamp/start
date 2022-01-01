class CreateTopInvitations < ActiveRecord::Migration[5.2]
  def change
    create_table :top_invitations do |t|
      t.string :email
      t.string :token, limit: 10

      t.timestamps
    end
  end
end
