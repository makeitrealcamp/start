class UpdateUsersActivityEmail < ActiveRecord::Migration[5.0]
  def change
    User.all.each do |t|
      t.settings[:activity_email] = true
      t.save!
    end
  end
end
