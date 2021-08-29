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
    email      "test@example.com"
    first_name "Pedro"
    last_name  "Perez"
    country    "CO"
    mobile     "3224567756"
  end

  factory :top_applicant, parent: :applicant, class: "TopApplicant" do
    info { { "version" => "2" } }
  end

  factory :innovate_applicant, parent: :applicant, class: "InnovateApplicant" do

  end
end
