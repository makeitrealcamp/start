class CreateTopApplicantTests < ActiveRecord::Migration
  def change
    create_table :top_applicant_tests do |t|
      t.references :applicant, index: true, foreign_key: true
      t.string :a1
      t.text :a2
      t.text :a3
      t.text :a4
      t.text :comments

      t.timestamps null: false
    end
  end
end
