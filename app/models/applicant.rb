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
#  status     :integer          default(0)
#  info       :hstore
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  cohort_id  :bigint
#
# Indexes
#
#  index_applicants_on_cohort_id  (cohort_id)
#

class Applicant < ApplicationRecord
  belongs_to :cohort, optional: true
  has_many :activities, class_name: "ApplicantActivity"
  has_many :note_activities, class_name: "NoteApplicantActivity"
  has_many :email_activities, class_name: "EmailApplicantActivity"
  has_many :change_status_activities, class_name: "ChangeStatusApplicantActivity"

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.find_by_status_and_cohort(status, cohort)
    results = all.where(status: TopApplicant.statuses[status])
    results = results.where(cohort_id: cohort) if cohort
    results
  end
end
