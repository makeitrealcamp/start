class AddColumnTypeApplicantActivity < ActiveRecord::Migration
  def change
  	add_column :applicant_activities, :type, :string
  end
end
