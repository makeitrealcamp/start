class MakeProfilesPrivateByDefault < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        User.all.find_each do |u|
          u.has_public_profile = false
          u.save
        end
      end
    end
  end
end
