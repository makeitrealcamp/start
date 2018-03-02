# == Schema Information
#
# Table name: applicant_activities
#
#  id           :integer          not null, primary key
#  applicant_id :integer
#  user_id      :integer
#  comment_type :integer
#  comment      :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  info         :hstore
#

class ChangeStatusApplicationActivity < ApplicantActivity
  hstore_accessor :info,
  current_status: :string,
  past_status:    :string
end
