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
# Indexes
#
#  index_auth_providers_on_user_id  (user_id)
#

class AuthProvider < ApplicationRecord
  belongs_to :user

  validates :uid, :provider, :user,  presence: true

  def self.omniauth(auth)
    user = User.where(email: auth.info.email).take

    if user
      user.auth_providers.where(provider: auth.provider, uid: auth.uid).first_or_create(image: auth.info.image)
      return user
    end
  end
end
