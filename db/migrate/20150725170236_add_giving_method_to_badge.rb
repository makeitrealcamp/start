class AddGivingMethodToBadge < ActiveRecord::Migration
  def change
    add_column :badges, :giving_method, :integer
  end
end
