class AddCompletedAtToResourceCompletion < ActiveRecord::Migration
  def change
    change_table :resources_users do |t|
      t.timestamps
    end

    reversible do |dir|
      dir.up do
        d = DateTime.new(2015,01,01)
        ResourceCompletion.update_all(created_at: d)
      end
    end
  end
end
