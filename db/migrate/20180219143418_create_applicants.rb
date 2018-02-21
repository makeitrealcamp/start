class CreateApplicants < ActiveRecord::Migration
  def change
    create_table :applicants do |t|
      t.string :type, limit: 30
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :country, limit: 3
      t.string :mobile, limit: 20
      t.integer :status, default: 0
      t.hstore :info

      t.timestamps null: false
    end
  end
end
