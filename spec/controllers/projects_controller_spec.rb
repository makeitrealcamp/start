require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  render_views

  describe "GET #show" do
    let(:project) { create(:project) }

    context "when not signed in" do
      it "redirects to login" do
        get :show, id: project.id, course_id: project.course_id
        expect(response).to redirect_to login_path
      end
    end

    context "when signed in" do
      let(:user) { create(:user) }
      before { controller.sign_in(user) }

      it "logs the activity" do
        expect {
          get :show, id: project.id, course_id: project.course_id
        }.to change(ActivityLog, :count).by(1)
      end
    end
  end
end
