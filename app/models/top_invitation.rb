# == Schema Information
#
# Table name: top_invitations
#
#  id         :bigint           not null, primary key
#  email      :string
#  token      :string(10)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class TopInvitation < ApplicationRecord
  before_create :generate_token

  validates :email, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  protected
    def generate_token
      begin
        self.token = 6.times.map { Random.rand(10) }.join("")
      end while self.class.exists?(["token = ?", self.token])
    end
end
