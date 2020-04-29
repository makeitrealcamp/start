class CreateWebinarsWebinars < ActiveRecord::Migration[5.1]
  def change
    create_table :webinars_webinars do |t|
      t.string :title, limit: 150, null: false
      t.string :slug, limit: 100, null: false
      t.text :description
      t.datetime :date, null: false
      t.string :image_url
      t.string :event_url

      t.timestamps
    end
  end
end
