# == Schema Information
#
# Table name: innovate_applicant_tests
#
#  id           :bigint           not null, primary key
#  applicant_id :bigint
#  lang         :integer
#  a1           :string
#  a2           :string
#  a3           :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_innovate_applicant_tests_on_applicant_id  (applicant_id)
#
class InnovateApplicantTest < ApplicationRecord
  belongs_to :applicant

  validates :applicant, :a1, :a2, :a3, presence: true
end
