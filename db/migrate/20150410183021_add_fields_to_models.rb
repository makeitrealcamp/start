class AddFieldsToModels < ActiveRecord::Migration
  def change
    add_column :users, :account_type, :integer
    add_column :courses, :visibility, :integer


    reversible do |dir|
      dir.up do
        User.update_all(account_type: User.account_types[:free_account])
      end
    end
  end
end