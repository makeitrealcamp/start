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
class TopCohort < Cohort

end
