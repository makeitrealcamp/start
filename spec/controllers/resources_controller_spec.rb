require 'rails_helper'

RSpec.describe ResourcesController, type: :controller do
  render_views

  describe "GET #show" do
    let(:resource) { create(:external_url) }

    context "when not signed in" do
      it "redirects to login" do
        get :show, params: { id: resource.slug, subject_id: resource.subject_id }
        expect(response).to redirect_to login_path
      end
    end

    context "when signed in" do
      let(:user) { create(:user) }
      before { controller.sign_in(user) }

      it "logs the activity if the resource is markdown" do
        markdown = create(:markdown, content: "Hey")

        expect {
          get :show, params: { id: markdown.slug, subject_id: markdown.subject_id }
        }.to change(ActivityLog, :count).by(1)
      end

      it "doesn't logs the activity if the resource is not markdown" do
        expect {
          get :show, params: { id: resource.slug, subject_id: resource.subject_id }
        }.to_not change(ActivityLog, :count)
      end
    end
  end

  describe "GET #open" do
    let(:resource) { create(:external_url) }

    context "when not signed in" do
      it "redirects to login" do
        get :open, params: { id: resource.slug, subject_id: resource.subject_id }
        expect(response).to redirect_to login_path
      end
    end

    context "when signed in" do
      let(:user) { create(:user) }
      before { controller.sign_in(user) }

      it "logs the activity" do
        expect {
          get :open, params: { id: resource.slug, subject_id: resource.subject_id }
        }.to change(ActivityLog, :count).by(1)
      end
    end
  end
end
