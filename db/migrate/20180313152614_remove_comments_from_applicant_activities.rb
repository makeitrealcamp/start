class RemoveCommentsFromApplicantActivities < ActiveRecord::Migration
  def change
    remove_column :applicant_activities, :comment_type
    remove_column :applicant_activities, :comment
  end
end
