class RenameBadgesUsersToBadgeOwnerships < ActiveRecord::Migration
  def change
    rename_table :badges_users, :badge_ownerships
  end
end
