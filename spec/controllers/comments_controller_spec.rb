require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  render_views

  shared_examples "comment editor" do
    before { xhr :get, :edit, id: comment.id }
    it { expect(response).to be_success }
    it { expect(response).to render_template :edit }
  end

  shared_examples "comment updater" do
    it "updates the comment if the body is not empty" do
      text = "otro texto"

      xhr :patch, :update, id: comment.id, text: text
      expect(response).to be_success

      comment.reload
      expect(comment.text).to eq(text)
    end

    it "doesn't update the comment if the body is empty" do
      original_text = comment.text

      xhr :patch, :update, id: comment.id, text: ""
      expect(response).to be_success

      comment.reload
      expect(comment.text).to eq(original_text)
    end
  end

  shared_examples "comment deleter" do
    it "deletes the comment" do
      expect {
        xhr :delete, :destroy, id: comment.id
      }.to change(Comment, :count).by(-1)
    end
  end

  let!(:user)       { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:admin )     { create(:admin) }
  let!(:course)     { create(:course) }
  let!(:challenge)  { create(:challenge, course: course) }
  let!(:solution)   { create(:solution, user: user, challenge: challenge, status: :completed, completed_at: 1.week.ago) }
  let!(:comment)    { create(:comment, user: user, commentable: challenge) }

  describe "POST #create" do
    context "when not signed in" do
      it "redirects to login" do
        xhr :post, :create, commentable_resource: "challenges", id: challenge.id, text: "hola mundo"
        expect(response).to redirect_to :login
      end
    end

    context "when signed in" do
      before { controller.sign_in(user) }

      it "creates the comment if body is not empty" do
        expect {
          xhr :post, :create, commentable_resource: "challenges", id: challenge.id, text: "hola mundo"
        }.to change(Comment, :count).by(1)
      end

      it "doesn't create the comment if body is empty" do
        expect {
          xhr :post, :create, commentable_resource: "challenges", id: challenge.id, text: ""
        }.to_not change(Comment, :count)
      end
    end
  end

  describe "GET #edit" do
    context "when not signed in" do
      it "redirects to login" do
        get :edit, id: comment.id
        expect(response).to redirect_to :login
      end
    end

    context "when user is admin" do
      before { controller.sign_in(admin) }
      it_behaves_like "comment editor"
    end

    context "when user is the owner of the comment" do
      before { controller.sign_in(user) }
      it_behaves_like "comment editor"
    end

    context "when user is not the owner of the comment" do
      it "raises a routing error" do
        controller.sign_in(other_user)
        expect { xhr :get, :edit, id: comment.id }.to raise_error(ActionController::RoutingError)
      end
    end
  end

  describe "PATCH #update" do
    context "when not signed in" do
      it "redirects to login" do
        xhr :patch, :update, id: comment.id, text: "hola mundo"
        expect(response).to redirect_to :login
      end
    end

    context "when user is admin" do
      before { controller.sign_in(admin) }
      it_behaves_like "comment updater"
    end

    context "when user is the owner of the comment" do
      before { controller.sign_in(user) }
      it_behaves_like "comment updater"
    end

    context "when user is not the owner of the comment" do
      before { controller.sign_in(other_user) }

      it "doesn't update the comment and raises a routing error" do
        original_text = comment.text

        expect {
          xhr :patch, :update, id: comment.id, text: "nuevo texto"
        }.to raise_error(ActionController::RoutingError)

        comment.reload
        expect(comment.text).to eq(original_text)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when not signed in" do
      it "redirects to login" do
        xhr :delete, :destroy, id: comment.id
        expect(response).to redirect_to :login
      end
    end

    context "when user is admin" do
      before { controller.sign_in(admin) }
      it_behaves_like "comment deleter"
    end

    context "when user is the owner of the comment" do
      before { controller.sign_in(admin) }
      it_behaves_like "comment deleter"
    end

    context "when user is not the owner of the comment" do
      before { controller.sign_in(other_user) }

      it "doesn't delete the comment and raises a routing error" do
        original_text = comment.text

        expect {
          xhr :delete, :destroy, id: comment.id
        }.to raise_error(ActionController::RoutingError)

        comment.reload
        expect(comment.text).to eq(original_text)
      end
    end
  end

  describe "GET #response_to" do

  end
end