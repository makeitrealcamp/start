class AddPriceToResource < ActiveRecord::Migration
  def change
    add_column :resources, :price, :decimal
  end
end
