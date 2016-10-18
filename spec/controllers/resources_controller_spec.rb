require 'rails_helper'

RSpec.describe ResourcesController, type: :controller do
  render_views

  describe "GET #show" do
    let(:resource) { create(:resource) }

    context "when not signed in" do
      it "redirects to login" do
        get :show, id: resource.slug, subject_id: resource.subject_id
        expect(response).to redirect_to login_path
      end
    end

    context "when signed in" do
      let(:user) { create(:user) }
      before { controller.sign_in(user) }

      it "logs the activity if the resource is markdown" do
        resource.update(type: :markdown, content: "Hey")

        expect {
          get :show, id: resource.slug, subject_id: resource.subject_id
        }.to change(ActivityLog, :count).by(1)
      end

      it "doesn't logs the activity if the resource is not markdown" do
        expect {
          get :show, id: resource.slug, subject_id: resource.subject_id
        }.to_not change(ActivityLog, :count)
      end
    end
  end

  describe "GET #open" do
    let(:resource) { create(:resource) }

    context "when not signed in" do
      it "redirects to login" do
        get :open, id: resource.slug, subject_id: resource.subject_id
        expect(response).to redirect_to login_path
      end
    end

    context "when signed in" do
      let(:user) { create(:user) }
      before { controller.sign_in(user) }

      it "logs the activity" do
        expect {
          get :open, id: resource.slug, subject_id: resource.subject_id
        }.to change(ActivityLog, :count).by(1)
      end
    end
  end
end
