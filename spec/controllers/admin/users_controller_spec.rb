require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  render_views

  describe "GET #index" do
    context "when not signed in" do
      it "redirects to login" do
        get :index
        expect(response).to redirect_to(admin_login_path)
      end
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

    it "filters users by email" do
      u1 = create(:user, email: "test1@example.com")
      create(:user, email: "person1@example.com")
      u2 = create(:user, email: "test2@example.com")
      create(:user, email: "person2@example.com")

      get :index, params: { q: "tESt" }
      expect(assigns(:users)).to match_array([u1, u2])
    end

    it "filters users by name" do
      create(:user, profile: { first_name: "John" })
      u1 = create(:user, profile: { last_name: "Mellark" })
      create(:user, profile: { first_name: "John", last_name: "Doe" })
      u2 = create(:user, profile: { first_name: "Peter", last_name: "Mellark" })

      get :index, params: { q: "mella" }
      expect(assigns(:users)).to match_array([u1, u2])
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
        get :new, xhr: true
        expect(response).to render_template :new
      end
    end
  end

  describe "POST #create" do
    let(:atts) { attributes_for(:user) }

    context "when not signed in" do
      it "redirects to login" do
        post :create, params: atts
        expect(response).to redirect_to(admin_login_path)
      end
    end

    context "when not an admin" do
      before { controller.sign_in(create(:user)) }

      it "redirects to login" do
        post :create, params: { user: atts }
        expect(response).to redirect_to(admin_login_path)
      end
    end

    context "when admin" do
      before { controller.sign_in(create(:admin_user)) }

      context "with valid input" do
        it "assigns a valid user" do
          post :create, params: { user: atts }, xhr: true
          expect(assigns(:user)).to be_valid
        end

        it "renders template create" do
          post :create, params: { user: atts }, xhr: true
          expect(response).to render_template :create
        end

        it "sends welcome email" do
          expect { post :create, params: { user: atts }, xhr: true }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end
      end

      context "when email has upper case letters" do
        it "changes it to lower case" do
          post :create, params: { user: atts.merge(email: "TeSt@exAmPle.com") }, xhr: true
          expect(assigns(:user).email).to eq("test@example.com")
        end
      end

      context "with invalid input" do
        it "assigns an invalid user" do
          post :create, params: { user: atts.merge(email: nil) }, xhr: true
          expect(assigns(:user)).to_not be_valid
        end
      end
    end
  end

  describe "GET #edit" do
    let(:user) { create(:user) }

    context "when not signed in" do
      it "redirects to login" do
        get :edit, params: { id: user.id }
        expect(response).to redirect_to(admin_login_path)
      end
    end

    context "when not an admin" do
      before { controller.sign_in(create(:user)) }

      it "redirects to login" do
        get :edit, params: { id: user.id }
        expect(response).to redirect_to(admin_login_path)
      end
    end

    context "when admin" do
      before do
        admin = create(:admin_user)
        controller.sign_in(admin)
      end

      it "renders template new" do
        get :edit, params: { id: user.id }, xhr: true
        expect(response).to render_template :edit
      end
    end
  end

  describe "PATCH #update" do
    let(:user) { create(:user) }
    let(:atts) { attributes_for(:user) }

    context "when not signed in" do
      it "redirects to login" do
        patch :update, params: { id: user.id }
        expect(response).to redirect_to(admin_login_path)
      end
    end

    context "when not an admin" do
      before { controller.sign_in(create(:user)) }

      it "redirects to login" do
        patch :update, params: { id: user.id, user: atts }
        expect(response).to redirect_to(admin_login_path)
      end
    end

    context "when admin" do
      before { controller.sign_in(create(:admin_user)) }

      context "with invalid input" do
        it "is not valid" do
          patch :update, params: { id: user.id, user: atts.merge(email: nil) }, xhr: true

          expect(assigns(:user)).to_not be_valid
        end
      end
    end
  end
end
