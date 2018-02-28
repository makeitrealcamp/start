class CreateApplicantActivities < ActiveRecord::Migration
  def change
    create_table :applicant_activities do |t|
      t.integer :applicant_id;
      t.belongs_to :user;
      t.integer :comment_type;
      t.text :comment;
      t.timestamps null: false
    end
  end
end
