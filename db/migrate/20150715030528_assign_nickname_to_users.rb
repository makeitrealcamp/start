class AssignNicknameToUsers < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        User.all.find_each do |u|
          begin
            u.nickname = SecureRandom.hex(8)
          end while User.where.not(id: u.id).find_by_nickname(u.nickname)
          u.save
        end
      end
    end
  end
end
