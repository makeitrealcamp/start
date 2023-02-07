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
  enum status: [:applied, :test_sent, :test_received, :test_graded, :first_interview_scheduled, :second_interview_held, :accepted, :enrolled, :not_enrolled, :rejected, :interviews_completed, :gave_up, :graduated, :placed, :aspiring_course, :aspiring_course_confirmed]
  enum program: [:full, :partial]

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
    version: :integer,
    prev_salary: :integer,
    new_salary: :integer,
    company: :string,
    start_date: :string,
    contract_type: :string,
    socioeconomic_level: :integer,
    referred_by: :string,
    studies: :string,
    working: :string,
    aspiring_course_accepted: :boolean

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
      rejected: "rechazado",
      interviews_completed: "entrevistas finalizadas",
      gave_up: "desistió del proceso",
      graduated: "graduado",
      placed: "ubicado laboralmente",
      aspiring_course: "curso aspirante",
      aspiring_course_confirmed: "confirmó curso"
    }

    mappings[status.to_sym]
  end

  def self.status_segments(status)
    mappings = {
      applied: "Filled Top Application",
      test_sent: "Test Sent to Top Applicant",
      test_received: "Test Recieved from Top Applicant",
      test_graded: "Test graded of Top Applicant",
      first_interview_scheduled: "Accepted to TOP personal interview",
      second_interview_held: "Accepted to TOP tech interview",
      accepted: "Accepted to TOP",
      enrolled: "Erolled to TOP",
      not_enrolled: "Not enrolled to TOP",
      rejected: "Rejected from TOP",
      interviews_completed: "Completed TOP interviews",
      gave_up: "Desisted from TOP application",
      graduated: "Graduated from TOP",
      placed: "Placed from TOP",
      aspiring_course: "Accepted to  Aspirantes TOP",
      aspiring_course_confirmed: "Confirmed to Aspirantes TOP"
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
