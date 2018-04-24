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
    additional: :string

  protected
    def generate_uid
      begin
        self.uid = SecureRandom.hex(4)
      end while self.class.exists?(["info -> 'uid' = ?", self.uid])
    end
end
