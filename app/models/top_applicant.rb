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
#  status     :integer          default("applied")
#  info       :hstore
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  cohort_id  :bigint
#
# Indexes
#
#  index_applicants_on_cohort_id  (cohort_id)
#

class TopApplicant < Applicant
  enum status: [:applied, :test_sent, :test_received, :test_graded, :first_interview_scheduled, :second_interview_held, :accepted, :enrolled, :not_enrolled, :rejected]

  before_create :generate_uid

  hstore_accessor :info,
    uid: :string,
    valid_code: :boolean,
    accepted_terms: :boolean,
    birthday: :string,
    gender: :string,
    skype: :string,
    twitter: :string,
    url: :string,
    goal: :string,
    experience: :string,
    typical_day: :string,
    vision: :string,
    additional: :string,
    payment_method: :string,
    format: :string,
    stipend: :string,
    country: :string,
    version: :integer

  def self.model_name
    Applicant.model_name
  end

  def self.status_to_human(status)
    mappings = {
      applied: "aplicó",
      test_sent: "prueba enviada",
      test_received: "prueba recibida",
      test_graded: "prueba calificada",
      first_interview_scheduled: "primera entrevista",
      second_interview_held: "segunda entrevista",
      accepted: "aceptado",
      enrolled: "matriculado",
      not_enrolled: "no matriculado",
      rejected: "rechazado"
    }

    mappings[status.to_sym]
  end

  protected
    def generate_uid
      begin
        self.uid = SecureRandom.hex(4)
      end while self.class.exists?(["info -> 'uid' = ?", self.uid])
    end
end
