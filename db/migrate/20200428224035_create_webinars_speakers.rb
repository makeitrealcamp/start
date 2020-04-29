class CreateWebinarsSpeakers < ActiveRecord::Migration[5.1]
  def change
    create_table :webinars_speakers do |t|
      t.references :webinar, foreign_key: { to_table: :webinars_webinars, on_delete: :cascade }
      t.string :name, null: false
      t.string :avatar_url
      t.string :bio
      t.boolean :external, default: false

      t.timestamps
    end
  end
end
