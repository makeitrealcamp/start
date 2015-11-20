class InsertDefaultPathSubscriptions < ActiveRecord::Migration
  def change
    default_path = Path.first
    User.all.each do |u|
      PathSubscription.create(user_id: u.id,path_id: default_path.id)
    end
  end
end
