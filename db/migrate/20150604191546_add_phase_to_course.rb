class AddPhaseToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :phase, :integer
  end
end
