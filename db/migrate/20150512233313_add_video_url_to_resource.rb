class AddVideoUrlToResource < ActiveRecord::Migration
  def change
    add_column :resources, :video_url, :string
  end
end
