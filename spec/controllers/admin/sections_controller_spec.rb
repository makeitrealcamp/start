require 'rails_helper'

RSpec.describe SectionsController, type: :controller do
  let(:subject) { create(:subject) }
  let(:resource) { create(:resource, type: "Course", subject: subject) }
  let(:path_params) { { resource_id: resource.id, subject_id: subject.id } }

  describe "GET #new" do
    context "when not signed in" do
      it "redirects to login" do
        get :new, params: path_params, xhr: true
        expect(response).to redirect_to(admin_login_path)
      end
    end

    context "when not an admin" do
      before do
        user = create(:user)
        controller.sign_in(user)
      end

      it "redirects to login" do
        get :new, params: path_params, xhr: true
        expect(response).to redirect_to(admin_login_path)
      end
    end

    context "when admin" do
      before do
        admin = create(:admin_user)
        controller.sign_in(admin)
      end

      it "renders template new" do
        get :new, params: path_params, xhr: true
        expect(response).to render_template :new
      end
    end
  end

  describe "POST #create" do
    let(:atts) { attributes_for(:section) }

    context "when not signed in" do
      it "redirects to login" do
        post :create, params: path_params.merge(section: atts), xhr: true
        expect(response).to redirect_to(admin_login_path)
      end
    end

    context "when not an admin" do
      before do
        user = create(:user)
        controller.sign_in(user)
      end

      it "redirects to login" do
        post :create, params: path_params.merge(section: atts), xhr: true
        expect(response).to redirect_to(admin_login_path)
      end
    end

    context "when admin" do
      before do
        admin = create(:admin_user)
        controller.sign_in(admin)
      end

      context "with valid attributes" do
        it "renders template create" do
          post :create, params: path_params.merge(section: atts), xhr: true
          expect(response).to render_template :create
        end

        it "creates the section" do
          expect {
            post :create, params: path_params.merge(section: atts), xhr: true
          }.to change(Section, :count).by(1)
        end
      end

      context "with invalid attributes" do
        it "renders template create" do
          post :create, params: path_params.merge(section: { title: "" }), xhr: true
          expect(response).to render_template :create
        end

        it "doesn't creates the section" do
          expect {
            post :create, params: path_params.merge(section: { title: "" }), xhr: true
          }.to_not change(Section, :count)
        end
      end
    end
  end
end
