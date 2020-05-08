class CreateWebinarsParticipants < ActiveRecord::Migration[5.1]
  def change
    create_table :webinars_participants do |t|
      t.references :webinar, foreign_key: { to_table: :webinars_webinars, on_delete: :cascade }
      t.string :email, limit: 150, null: false
      t.string :first_name, limit: 100, null: false
      t.string :last_name, limit: 100, null: false
      t.string :token, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
