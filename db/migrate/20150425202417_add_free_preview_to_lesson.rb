class AddFreePreviewToLesson < ActiveRecord::Migration
  def change
    add_column :lessons, :free_preview, :boolean, default: false
  end
end
