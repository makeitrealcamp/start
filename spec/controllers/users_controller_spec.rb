require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let!(:user_with_private_profile) { create(:user, has_public_profile: false) }
  let!(:user_with_public_profile) { create(:user, has_public_profile: true) }
  let!(:admin) { create(:admin) }

  before do
    cookies.delete(:user_id)
  end

  describe "#profile" do
    describe "access" do
      it "should allow access to public profiles" do
        xhr :get, :profile, nickname: user_with_public_profile.nickname
        expect(response).to have_http_status(:ok)
      end

      it "should not allow access to private profiles" do
        expect{ xhr :get, :profile, nickname: user_with_private_profile.nickname }.to raise_error(ActionController::RoutingError)
      end

      it "should allow access to private profiles by admins" do
        #sign in admin
        cookies.permanent.signed[:user_id] = admin.id
        xhr :get, :profile, nickname: user_with_private_profile.nickname
        expect(response).to have_http_status(:ok)
      end

    end
  end

end
