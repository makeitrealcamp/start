class AddPreviewToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :preview, :boolean, default: true
  end
end
