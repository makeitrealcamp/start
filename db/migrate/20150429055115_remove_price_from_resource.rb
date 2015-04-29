class RemovePriceFromResource < ActiveRecord::Migration
  def change
    remove_column :resources, :price, :decimal
  end
end
