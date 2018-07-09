require 'rails_helper'

RSpec.describe Admin::BadgesController, type: :controller do
  render_views

  describe "GET #index" do
    context "when not signed in" do
      it "raises a routing error" do
        expect { get :index }.to raise_error ActionController::RoutingError
      end
    end

    context "when not an admin" do
      before do
        user = create(:user)
        controller.sign_in(user)
      end

      it "raises a routing error" do
        expect { get :index }.to raise_error ActionController::RoutingError
      end
    end

    context "when admin" do
      before do
        admin = create(:admin)
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
      it "raises a routing error" do
        expect { get :new }.to raise_error ActionController::RoutingError
      end
    end

    context "when not an admin" do
      before do
        user = create(:user)
        controller.sign_in(user)
      end

      it "raises a routing error" do
        expect { get :new }.to raise_error ActionController::RoutingError
      end
    end

    context "when admin" do
      before do
        admin = create(:admin)
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
      it "raises a routing error" do
        expect { post :create, params: atts }.to raise_error ActionController::RoutingError
      end
    end

    context "when not an admin" do
      before do
        user = create(:user)
        controller.sign_in(user)
      end

      it "raises a routing error" do
        expect { post :create, params: atts }.to raise_error ActionController::RoutingError
      end
    end
  end

  describe "GET #edit" do
    let(:badge) { create(:badge) }

    context "when not signed in" do
      it "raises a routing error" do
        expect { get :edit, params: { id: badge.id } }.to raise_error ActionController::RoutingError
      end
    end

    context "when not an admin" do
      before do
        user = create(:user)
        controller.sign_in(user)
      end

      it "raises a routing error" do
        expect { get :edit, params: { id: badge.id } }.to raise_error ActionController::RoutingError
      end
    end
  end

  describe "PATCH #update" do
    let(:badge) { create(:badge) }

    context "when not signed in" do
      it "raises a routing error" do
        expect { patch :update, params: { id: badge.id } }.to raise_error ActionController::RoutingError
      end
    end

    context "when not an admin" do
      before do
        user = create(:user)
        controller.sign_in(user)
      end

      it "raises a routing error" do
        expect { patch :update, params: { id: badge.id } }.to raise_error ActionController::RoutingError
      end
    end
  end

  describe "DELETE #destroy" do
    let(:badge) { create(:badge) }

    context "when not signed in" do
      it "raises a routing error" do
        expect { delete :destroy, params: { id: badge.id } }.to raise_error ActionController::RoutingError
      end
    end

    context "when not an admin" do
      before do
        user = create(:user)
        controller.sign_in(user)
      end

      it "raises a routing error" do
        expect { delete :destroy, params: { id: badge.id } }.to raise_error ActionController::RoutingError
      end
    end
  end
end
