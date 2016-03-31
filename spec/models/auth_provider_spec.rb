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

  describe ".omniauth" do
    context "when user doesn't exists" do
      it "returns nil" do
        expect(AuthProvider.omniauth(mock_auth_hash_slack(build(:user)))).to be_nil
        expect(User.count).to eq(0)
        expect(AuthProvider.count).to eq(0)
      end

      it "doesn't create the user" do
        expect {
          AuthProvider.omniauth(mock_auth_hash_slack(build(:user)))
        }.not_to change(User, :count)
      end

      it "doesn't create the auth_provider" do
        expect {
          AuthProvider.omniauth(mock_auth_hash_slack(build(:user)))
        }.not_to change(AuthProvider, :count)
      end
    end

    context "when user exists" do
      let(:user) { create(:user) }

      context "and auth hash corresponds to user" do
        context "if auth provider doesn't exists" do
          it "returns the user" do
            returned_user = AuthProvider.omniauth(mock_auth_hash_slack(user))
            expect(returned_user).not_to be_nil
            expect(returned_user.id).to eq(user.id)
          end

          it "creates the auth provider" do
            expect {
              AuthProvider.omniauth(mock_auth_hash_slack(user))
            }.to change(AuthProvider, :count).by(1)
          end
        end

        context "if the auth provider exists" do
          let(:auth_hash) { mock_auth_hash_slack(user) }
          before { create(:auth_provider, user: user, uid: auth_hash.uid, provider: auth_hash.provider) }

          it "returns the user" do
            returned_user = AuthProvider.omniauth(mock_auth_hash_slack(user))
            expect(returned_user).not_to be_nil
            expect(returned_user.id).to eq(user.id)
          end

          it "doesn't creates a new auth provider" do
            expect {
              AuthProvider.omniauth(mock_auth_hash_slack(user))
            }.not_to change(AuthProvider, :count)
          end
        end
      end

      context "and auth hash doesn't corresponds to user" do
        it "doesn't creates the auth provider" do
          auth_hash = mock_auth_hash_slack(build(:user))

          expect(AuthProvider.omniauth(auth_hash)).to be_nil
          expect(AuthProvider.count).to eq(0)
        end
      end

    end
  end
end
