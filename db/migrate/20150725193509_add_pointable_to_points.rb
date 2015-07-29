class AddPointableToPoints < ActiveRecord::Migration
  def change
    add_reference :points, :pointable, polymorphic: true, index: true
  end
end
