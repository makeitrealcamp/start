# == Schema Information
#
# Table name: top_applicant_tests
#
#  id           :integer          not null, primary key
#  applicant_id :integer
#  a1           :string
#  a2           :text
#  a3           :text
#  a4           :text
#  comments     :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_top_applicant_tests_on_applicant_id  (applicant_id)
#

FactoryGirl.define do
  factory :top_applicant_test do
    applicant nil
a1 "MyString"
a2 "MyText"
a3 "MyText"
a4 "MyText"
comments "MyText"
  end

end
