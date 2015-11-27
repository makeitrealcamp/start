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
  let!(:user){ create(:user) }
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
        AuthProvider.omniauth(mock_auth_hash_slack(user))
        expect(User.count).to eq 1
      end
    end

    context 'when user is found' do
      it 'return false' do
        AuthProvider.omniauth(mock_auth_hash_slack(user))
        expect(User.count).not_to eq 2
      end

      context 'auth_provider by slack is not found'  do
        it 'return 1' do
          create(:user, email: "user@makeitreal.camp")
          AuthProvider.omniauth(mock_auth_hash_slack(user))
          expect(AuthProvider.count).to eq 1
        end
      end

      context 'auth_provider by slack is found'  do
        it 'return false' do
          user = create(:user, email: "user@makeitreal.camp")
          create(:auth_provider, provider: "slack", user: user)
          AuthProvider.omniauth(mock_auth_hash_slack(user))
          expect(AuthProvider.count).not_to eq 2
        end
      end
    end
  end
end
