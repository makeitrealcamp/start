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
FactoryGirl.define do
  factory :innovate_applicant_test do
    applicant nil
lang 1
a1 "MyString"
a2 "MyString"
a3 "MyString"
  end

end
