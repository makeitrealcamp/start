# == Schema Information
#
# Table name: auth_providers
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  provider   :string
#  uid        :string
#  image      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AuthProvider < ActiveRecord::Base
  belongs_to :user

  validates :uid, :provider, :user,  presence: true

  def self.omniauth(auth)
    puts "Auth: #{auth.info}"
    user = User.where(email: auth.info.email).first_or_create!(password: SecureRandom.urlsafe_base64)
    user.auth_providers.where(provider: auth.provider, uid: auth.uid).first_or_create(image: auth.info.image)
    user
  end
end
