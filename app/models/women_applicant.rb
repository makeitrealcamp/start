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
class WomenApplicant < Applicant
  enum status: [:applied, :accepted, :enrolled, :not_enrolled, :rejected, :gave_up, :graduated]
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
      accepted: "aceptado",
      enrolled: "matriculado",
      not_enrolled: "no matriculado",
      rejected: "rechazado",
      gave_up: "desistió del proceso",
      graduated: "graduado",
    }

    mappings[status.to_sym]
  end

  def self.status_segments(status)
    mappings = {
      applied: "Filled Nesst Women Bootcamp Application",
      accepted: "Accepted to Nesst Women Bootcamp",
      enrolled: "Erolled to Nesst Women Bootcamp",
      not_enrolled: "Not enrolled to Nesst Women Bootcamp",
      rejected: "Rejected from Nesst Women Bootcamp",
      gave_up: "Desisted from Nesst Women Bootcamp application",
      graduated: "Graduated from Nesst Women Bootcamp"
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
