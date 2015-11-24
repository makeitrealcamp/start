class AddPublishedToPaths < ActiveRecord::Migration
  def change
    add_column :paths, :published, :boolean, default: false
  end
end
