class UpdateUsersActivityEmail < ActiveRecord::Migration[5.0]
  def change
    User.all.each do |t|
      t.activity_email = true
      t.save!
    end
  end
end
