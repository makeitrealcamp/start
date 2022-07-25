class AddGroupToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :group, index: true, foreign_key: { on_delete: :cascade }

    reversible do |dir|
      dir.up do
        Group.create!(name: "nominapp")
      end
    end
  end
end
