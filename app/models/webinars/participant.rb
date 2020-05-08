# == Schema Information
#
# Table name: webinars_participants
#
#  id         :bigint           not null, primary key
#  webinar_id :bigint
#  email      :string(150)      not null
#  first_name :string(100)      not null
#  last_name  :string(100)      not null
#  token      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_webinars_participants_on_token       (token) UNIQUE
#  index_webinars_participants_on_webinar_id  (webinar_id)
#
class Webinars::Participant < ApplicationRecord
  belongs_to :webinar
  before_create :generate_token

  validates :email, :first_name, :last_name, presence: true

  def generate_token
    begin
      self.token = SecureRandom.hex(4)
    end while self.class.exists?(token: self.token)
  end
end
