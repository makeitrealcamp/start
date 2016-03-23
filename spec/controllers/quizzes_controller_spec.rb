require 'rails_helper'

RSpec.describe Quizer::QuizzesController, type: :controller do
  render_views

  describe "GET #show" do
    let!(:quiz) { create(:quiz) }

    context "when not signed in" do
      it "redirects to login" do
        get :show, id: quiz.id, course_id: quiz.course_id
        expect(response).to redirect_to :login
      end
    end

    context "when signed in" do
      let(:user) { create(:user) }
      before { controller.sign_in(user) }
      
      it "renders template show" do
        get :show, id: quiz.id, course_id: quiz.course_id
        expect(response).to render_template :show
      end
    end
  end
end