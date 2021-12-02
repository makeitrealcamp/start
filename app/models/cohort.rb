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
class Cohort < ApplicationRecord
  has_many :applicants

  validates :name, presence: true

  def name_with_num_applicants
    "#{name} (#{applicants.count})"
  end
end
