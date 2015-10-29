class AddTimeoutToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :timeout, :integer
  end
end
