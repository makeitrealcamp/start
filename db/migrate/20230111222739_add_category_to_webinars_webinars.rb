class AddCategoryToWebinarsWebinars < ActiveRecord::Migration[5.2]
  def change
    add_column :webinars_webinars, :category, :integer, default: 0
  end
end
