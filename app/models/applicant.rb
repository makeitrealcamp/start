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
#  status     :integer          default("0")
#  info       :hstore
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Applicant < ApplicationRecord
  has_many :activities, class_name: "ApplicantActivity"
  has_many :note_activities, class_name: "NoteApplicantActivity"
  has_many :email_activities, class_name: "EmailApplicantActivity"
  has_many :change_status_activities, class_name: "ChangeStatusApplicantActivity"

  def full_name
    "#{first_name} #{last_name}"
  end
end
