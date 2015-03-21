class AddPublishedToResources < ActiveRecord::Migration
  def change
    add_column :resources, :published, :boolean
    reversible do |dir|
      dir.up { Resource.update_all(published: true) }
    end
  end
end
