class AddColumnToApplicantActivities < ActiveRecord::Migration
  def change
    add_column :applicant_activities, :info, :hstore
  end
end
