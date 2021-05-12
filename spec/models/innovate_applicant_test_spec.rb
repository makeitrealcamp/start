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
require 'rails_helper'

RSpec.describe InnovateApplicantTest, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
