require 'rails_helper'

RSpec.describe Admin::BadgesController, type: :controller do
  render_views

  describe "GET #index" do
    context "when not signed in" do
      it "redirects to login" do
        get :index
        expect(response).to redirect_to(admin_login_path)
      end
    end

    context "when not an admin" do
      before do
        user = create(:user)
        controller.sign_in(user)
      end

      it "redirects to login" do
        get :index
        expect(response).to redirect_to(admin_login_path)
      end
    end

    context "when admin" do
      before do
        admin = create(:admin_user)
        controller.sign_in(admin)
      end

      it "renders template index" do
        get :index
        expect(response).to render_template :index
      end
    end
  end

  describe "GET #new" do
    context "when not signed in" do
      it "redirects to login" do
        get :new
        expect(response).to redirect_to(admin_login_path)
      end
    end

    context "when not an admin" do
      before do
        user = create(:user)
        controller.sign_in(user)
      end

      it "redirects to login" do
        get :new
        expect(response).to redirect_to(admin_login_path)
      end
    end

    context "when admin" do
      before do
        admin = create(:admin_user)
        controller.sign_in(admin)
      end

      it "renders template new" do
        get :new
        expect(response).to render_template :new
      end
    end
  end

  describe "POST #create" do
    let(:atts) { attributes_for(:badge) }

    context "when not signed in" do
      it "redirects to login" do
         post :create, params: atts
         expect(response).to redirect_to(admin_login_path)
      end
    end

    context "when not an admin" do
      before do
        user = create(:user)
        controller.sign_in(user)
      end

      it "redirects to login" do
        post :create, params: atts
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end

  describe "GET #edit" do
    let(:badge) { create(:badge) }

    context "when not signed in" do
      it "redirects to login" do
        get :edit, params: { id: badge.id }
        expect(response).to redirect_to(admin_login_path)
      end
    end

    context "when not an admin" do
      before do
        user = create(:user)
        controller.sign_in(user)
      end

      it "redirects to login" do
        get :edit, params: { id: badge.id }
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end

  describe "PATCH #update" do
    let(:badge) { create(:badge) }

    context "when not signed in" do
      it "redirects to login" do
        patch :update, params: { id: badge.id }
        expect(response).to redirect_to(admin_login_path)
      end
    end

    context "when not an admin" do
      before do
        user = create(:user)
        controller.sign_in(user)
      end

      it "redirects to login" do
        patch :update, params: { id: badge.id }
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end

  describe "DELETE #destroy" do
    let(:badge) { create(:badge) }

    context "when not signed in" do
      it "redirects to login" do
        delete :destroy, params: { id: badge.id }
        expect(response).to redirect_to(admin_login_path)
      end
    end

    context "when not an admin" do
      before do
        user = create(:user)
        controller.sign_in(user)
      end

      it "redirects to login" do
        delete :destroy, params: { id: badge.id }
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end
end
