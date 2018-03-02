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

class EmailApplicationActivity < ApplicantActivity
  hstore_accessor :info,
  subject:        :string,
  body:           :string
end
