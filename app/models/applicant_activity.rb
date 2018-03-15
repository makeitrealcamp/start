# == Schema Information
#
# Table name: applicant_activities
#
#  id           :integer          not null, primary key
#  applicant_id :integer
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  info         :hstore
#  type         :string
#

class ApplicantActivity < ActiveRecord::Base
  belongs_to :user
  belongs_to :applicant
end
