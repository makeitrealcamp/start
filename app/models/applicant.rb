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

  validates :email, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  enum rejected_reason: [:superficial_response, :no_experience, :technical_test_failed, :first_interview_failed, :low_english_level, :tecnical_interview_failed, :no_jointly_responsible]

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.find_by_status_and_cohort(status, cohort)
    results = all.where(status: TopApplicant.statuses[status])
    results = results.where(cohort_id: cohort) if cohort
    results
  end

  def self.rejected_reason_to_human(rejected_reason)
    mappings = {
      superficial_response: "Respuestas superficiales",
      no_experience: "No tiene la experiencia técnica (primer acercamiento a la programación)",
      technical_test_failed: "No pasó prueba técnica",
      first_interview_failed: "No pasó primera entrevista",
      low_english_level: "Inglés muy bajo",
      tecnical_interview_failed: "No pasó entrevista técnica",
      no_jointly_responsible: "No tiene responsable solidario"
    }

    mappings[rejected_reason.to_sym]
  end
end
