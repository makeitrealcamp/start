class AddPointToUsers < ActiveRecord::Migration
  def change
    add_column :users, :current_points, :integer, default: 0
    User.all.each do |u|
    	u.update_column(:current_points, u.points.sum(:points))
    end
  end
end
