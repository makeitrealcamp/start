class AddColumnStatusToApplicationActivity < ActiveRecord::Migration
  def change
  	add_column :applicant_activities, :current_status, :string
  	add_column :applicant_activities, :past_status, :string
  end
end
