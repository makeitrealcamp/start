class AddStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :status, :integer

    reversible do |dir|
      dir.up do
        User.all.each do |user|
          user.update(status: user.first_name.nil? ? 0 : 1)
        end
      end
    end
  end
end
