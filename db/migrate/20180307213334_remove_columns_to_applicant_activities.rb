class RemoveColumnsToApplicantActivities < ActiveRecord::Migration
  def change
    remove_column :applicant_activities, :past_status
    remove_column :applicant_activities, :current_status
    remove_column :applicant_activities, :body
    remove_column :applicant_activities, :subject
  end
end
