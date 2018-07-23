require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let!(:user_with_private_profile) { create(:user, has_public_profile: false) }
  let!(:user_with_public_profile) { create(:user, has_public_profile: true) }
  let!(:admin) { create(:admin) }

  describe "GET #profile" do
    it "allows public access to public profiles" do
      get :profile, params: { nickname: user_with_public_profile.nickname }
      expect(response).to have_http_status(:ok)
    end

    it "doesn't allow access to private profiles" do
      expect { get :profile, params: { nickname: user_with_private_profile.nickname } }.to raise_error(ActionController::RoutingError)
    end

    it "should allow access to private profiles by admins" do
      controller.sign_in(create(:admin))

      get :profile, params: { nickname: user_with_private_profile.nickname }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #edit" do
    let(:user) { create(:user) }

    context "when not signed in" do
      it "redirects to login" do
        get :edit, params: { id: user.id }
        expect(response).to redirect_to login_path
      end
    end

    context "when signed in" do
      let(:user) { create(:user) }
      before { controller.sign_in(user) }

      it "renders the template" do
        get :edit, params: { id: user.id }
        expect(response).to render_template :edit
      end

      it "doesn't allow to edit other user" do
        other_user = create(:user)

        expect { get :edit, params: { id: other_user.id } }.to raise_error(ActionController::RoutingError)
      end
    end

    context "when user is admin" do
      let(:admin) { create(:admin) }
      before { controller.sign_in(admin) }

      it "renders the edit template for any user" do
        other_user = create(:user)

        get :edit, params: { id: other_user.id }
        expect(response).to render_template :edit
      end
    end
  end

  describe "PATCH #update" do
    let(:user) { create(:user) }
    let(:atts) { attributes_for(:user) }

    context "when not signed in" do
      it "redirects to login" do
        patch :update, params: { id: user.id, user: atts }
        expect(response).to redirect_to login_path
      end
    end

    context "when signed in" do
      before { controller.sign_in(user) }

      context "with valid attributes" do
        it "updates the current user" do
          patch :update, params: { id: user.id, user: atts }
          expect(response).to redirect_to signed_in_root_path

          user.reload
          expect(user.first_name).to eq(atts[:first_name])
          expect(user.nickname).to eq(atts[:nickname])
        end

        it "doesn't update other user" do
          other_user = create(:user)
          expect { patch :update, params: { id: other_user.id, user: atts } }.to raise_error(ActionController::RoutingError)
        end
      end

      context "with invalid attributes" do
        it "renders the edit template" do
          patch :update, params: { id: user.id, user: attributes_for(:user, nickname: "wro.ng") }
          expect(response).to render_template :edit
        end
      end
    end
  end

end
