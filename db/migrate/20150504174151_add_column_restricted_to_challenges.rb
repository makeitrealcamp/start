class AddColumnRestrictedToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :restricted, :boolean, default: false
  end
end
