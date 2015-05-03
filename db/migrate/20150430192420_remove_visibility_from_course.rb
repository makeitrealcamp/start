class RemoveVisibilityFromCourse < ActiveRecord::Migration

  def change
    remove_column :courses, :visibility, :integer
  end
end