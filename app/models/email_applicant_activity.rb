# == Schema Information
#
# Table name: applicant_activities
#
#  id           :integer          not null, primary key
#  applicant_id :integer
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  info         :hstore
#  type         :string
#

class EmailApplicantActivity < ApplicantActivity
  belongs_to :applicant
  belongs_to :user

  validates :subject, :body, presence: true

  hstore_accessor :info,
    subject: :string,
    body: :string
end
