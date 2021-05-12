# == Schema Information
#
# Table name: applicants
#
#  id         :integer          not null, primary key
#  type       :string(30)
#  email      :string
#  first_name :string
#  last_name  :string
#  country    :string(3)
#  mobile     :string(20)
#  status     :integer          default("applied")
#  info       :hstore
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :applicant do
     email      "joshua@one.com"
     first_name "joshua"
     last_name  "prpich"
     country    "COL"
     mobile     3224567756
     status     0
  end

  factory :top_applicant, parent: :applicant, class: "TopApplicant" do

  end

  factory :innovate_applicant, parent: :applicant, class: "InnovateApplicant" do

  end
end
