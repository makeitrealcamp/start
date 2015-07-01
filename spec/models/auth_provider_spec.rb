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

require 'rails_helper'

RSpec.describe AuthProvider, type: :model do
  context 'associations' do
    it { should belong_to(:user) }
  end

  context 'validations' do
    it { should validate_presence_of :uid }
    it { should validate_presence_of :provider }
    it { should validate_presence_of :user }
  end

  describe '.omniauth' do
    context 'when user is not found' do
      it 'return 1' do
        AuthProvider.omniauth(mock_auth_hash_facebook)
        expect(User.count).to eq 1
      end
    end

    context 'when user is found' do
      it 'return false' do
        create(:user, email: "user@facebook.com")
        AuthProvider.omniauth(mock_auth_hash_facebook)
        expect(User.count).not_to eq 2
      end

      context 'auth_provider by facebook is not found'  do
        it 'return 1' do
          create(:user, email: "user@facebook.com")
          AuthProvider.omniauth(mock_auth_hash_facebook)
          expect(AuthProvider.count).to eq 1
        end
      end

      context 'auth_provider by facebook is found'  do
        it 'return false' do
          user = create(:user, email: "user@facebook.com")
          create(:auth_provider, provider: "facebook", user: user)
          AuthProvider.omniauth(mock_auth_hash_facebook)
          expect(AuthProvider.count).not_to eq 2
        end
      end

      context 'auth_provider by github is not found'  do
        it 'return 1' do
          create(:user, email: "user@github.com")
          AuthProvider.omniauth(mock_auth_hash_github)
          expect(AuthProvider.count).to eq 1
        end
      end

      context 'auth_provider by github is found'  do
        it 'return false' do
          user = create(:user, email: "user@github.com")
          create(:auth_provider, provider: "github", user: user)
          AuthProvider.omniauth(mock_auth_hash_github)
          expect(AuthProvider.count).not_to eq 2
        end
      end
    end
  end
end
