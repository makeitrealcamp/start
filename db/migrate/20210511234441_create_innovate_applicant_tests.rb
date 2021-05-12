class CreateInnovateApplicantTests < ActiveRecord::Migration[5.2]
  def change
    create_table :innovate_applicant_tests do |t|
      t.references :applicant, foreign_key: true
      t.integer :lang
      t.string :a1
      t.string :a2
      t.string :a3

      t.timestamps
    end
  end
end
