class AddColumnsToApplicantActivities < ActiveRecord::Migration
  def change
    add_column :applicant_activities, :subject, :string
    add_column :applicant_activities, :body, :text
  end
end
