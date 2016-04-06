class ChangeSuspendedUsers < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        users = User.where("profile -> 'suspended' = 'true'")
        users.update_all(status: 2) # 2 is suspended
      end

      dir.down do
        User.where(status: 2).update_all(status: 1)
      end
    end
  end
end
