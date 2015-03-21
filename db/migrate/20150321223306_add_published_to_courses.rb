class AddPublishedToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :published, :boolean

    reversible do |dir|
      dir.up { Course.update_all(published: true) }
    end
  end
end
