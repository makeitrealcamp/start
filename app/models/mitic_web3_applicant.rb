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

class MiticWeb3Applicant < Applicant

  enum status: [:applied, :test_sent, :test_received, :first_interview_scheduled, :interviews_completed, :preselected, :accepted, :rejected, :enrolled, :not_enrolled, :gave_up, :graduated, :placed]

  before_create :generate_uid

  hstore_accessor :info,
    uid: :string,
    country_code: :string,
    country: :string,
    accepted_terms: :boolean,
    birthday: :string,
    gender: :string,
    url: :string,
    goal: :string,
    experience: :string,
    additional: :string,
    studies: :string,
    working: :string,
    document_type: :string,
    document_number: :string,
    format: :string,
    payment_method: :string,
    format: :string,
    stipend: :string,
    version: :integer,
    prev_salary: :integer,
    new_salary: :integer,
    company: :string,
    start_date: :string,
    contract_type: :string,
    socioeconomic_level: :integer,
    referred_by: :string,
    program_name: :string,
    convertloop_event: :string
    
  def self.model_name
    Applicant.model_name
  end

  def self.status_to_human(status)
    mappings = {
      applied: "aplicó",
      test_sent: "TestGorilla eviado",
      test_received: "TestGorilla recibido",
      first_interview_scheduled: "primera entrevista",
      interviews_completed: "entrevistas finalizadas",
      preselected: "preseleccionado",
      accepted: "Aceptado",
      rejected: "Rechazado",
      enrolled: "Inscrito",
      not_enrolled: "no matriculado",
      gave_up: "desistió del proceso",
      graduated: "graduado",
      placed: "ubicado laboralmente",
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
