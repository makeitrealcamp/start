require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  render_views

  describe "GET #show" do
    let(:project) { create(:project) }

    context "when not signed in" do
      it "redirects to login" do
        get :show, params: { id: project.id, subject_id: project.subject_id }
        expect(response).to redirect_to login_path
      end
    end

    context "when signed in" do
      let(:user) { create(:user) }
      before { controller.sign_in(user) }

      it "renders the template" do
        get :show, params: { id: project.id, subject_id: project.subject_id }
        expect(response).to render_template :show
      end
    end
  end
end
