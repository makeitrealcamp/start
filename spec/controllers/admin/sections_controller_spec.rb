require 'rails_helper'

RSpec.describe SectionsController, type: :controller do
  let(:subject) { create(:subject) }
  let(:resource) { create(:resource, type: "Course", subject: subject) }
  let(:path_params) { { resource_id: resource.id, subject_id: subject.id } }

  describe "GET #new" do
    context "when not signed in" do
      it "raises a routing error" do
        expect { xhr :get, :new, path_params }.to raise_error ActionController::RoutingError
      end
    end

    context "when not an admin" do
      before do
        user = create(:user)
        controller.sign_in(user)
      end

      it "raises a routing error" do
        expect { xhr :get, :new, path_params }.to raise_error ActionController::RoutingError
      end
    end

    context "when admin" do
      before do
        admin = create(:admin)
        controller.sign_in(admin)
      end

      it "renders template new" do
        xhr :get, :new, path_params
        expect(response).to render_template :new
      end
    end
  end

  describe "POST #create" do
    let(:atts) { attributes_for(:section) }

    context "when not signed in" do
      it "raises a routing error" do
        expect { xhr :post, :create, path_params.merge(section: atts) }.to raise_error ActionController::RoutingError
      end
    end

    context "when not an admin" do
      before do
        user = create(:user)
        controller.sign_in(user)
      end

      it "raises a routing error" do
        expect { xhr :post, :create, path_params.merge(section: atts) }.to raise_error ActionController::RoutingError
      end
    end

    context "when admin" do
      before do
        admin = create(:admin)
        controller.sign_in(admin)
      end

      context "with valid attributes" do
        it "renders template create" do
          xhr :post, :create, path_params.merge(section: atts)
          expect(response).to render_template :create
        end

        it "creates the section" do
          expect {
            xhr :post, :create, path_params.merge(section: atts)
          }.to change(Section, :count).by(1)
        end
      end

      context "with invalid attributes" do
        it "renders template create" do
          xhr :post, :create, path_params.merge(section: { title: "" })
          expect(response).to render_template :create
        end

        it "doesn't creates the section" do
          expect {
            xhr :post, :create, path_params.merge(section: { title: "" })
          }.to_not change(Section, :count)
        end
      end
    end
  end
end
