class AddInfoToLesson < ActiveRecord::Migration
  def change
    add_column :lessons, :info, :text
  end
end
