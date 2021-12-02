# == Schema Information
#
# Table name: cohorts
#
#  id         :bigint           not null, primary key
#  name       :string
#  type       :string(30)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryGirl.define do
  factory :cohort do
    name "Activa"
  end

  factory :top_cohort, parent: :cohort, class: "TopCohort" do
  end

end
