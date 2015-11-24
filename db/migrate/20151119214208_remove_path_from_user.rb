class RemovePathFromUser < ActiveRecord::Migration
  def change
    remove_reference :users, :path
  end
end
