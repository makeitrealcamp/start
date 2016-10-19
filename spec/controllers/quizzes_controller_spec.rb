require 'rails_helper'

RSpec.describe Quizer::QuizzesController, type: :controller do
  render_views

  describe "GET #show" do
    let(:quiz) { create(:quiz) }

    context "when not signed in" do
      it "redirects to login" do
        get :show, id: quiz.id, subject_id: quiz.subject_id
        expect(response).to redirect_to :login
      end
    end

    context "when signed in" do
      let(:user) { create(:user) }
      before { controller.sign_in(user) }

      it "renders template show" do
        get :show, id: quiz.id, subject_id: quiz.subject_id
        expect(response).to render_template :show
      end
    end
  end

  describe "POST #create" do
    let(:subject) { create(:subject) }
    let(:atts) { attributes_for(:quiz) }

    context "when not signed in" do
      it "redirects to login" do
        post :create, subject_id: subject.id,  quiz: atts
        expect(response).to redirect_to :login
      end
    end
  end
end
