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
  hstore_accessor :info,
    accepted_terms: :boolean,
    birthday: :string,
    gender: :string,
    skype: :string,
    twitter: :string,
    url: :string,
    goal: :string,
    experience: :string,
    additional: :string

  enum status: [:applied, :test_sent, :test_received, :test_graded, :first_interview_scheduled, :second_interview_held, :accepted, :enrolled, :not_enrolled, :rejected]


end
