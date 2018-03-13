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

class ChangeStatusApplicantActivity < ApplicantActivity
  hstore_accessor :info,
    from_status: :string,
    to_status: :string,
    comment: :string
end
