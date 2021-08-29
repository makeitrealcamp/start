class AddColumnsToTopApplicantTest < ActiveRecord::Migration[5.2]
  def change
    add_column :top_applicant_tests, :lang, :integer, default: 0
  end
end
