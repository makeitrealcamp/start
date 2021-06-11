# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  commentable_id   :integer
#  commentable_type :string
#  text             :text
#  response_to_id   :integer
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_comments_on_commentable_type_and_commentable_id  (commentable_type,commentable_id)
#  index_comments_on_user_id                              (user_id)
#
require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  render_views

  shared_examples "comment editor" do
    before { get :edit, params: { id: comment.id }, xhr: true }
    it { expect(response).to be_successful }
    it { expect(response).to render_template :edit }
  end

  shared_examples "comment updater" do
    it "updates the comment if the body is not empty" do
      text = "otro texto"

      patch :update, params: { id: comment.id, text: text }, xhr: true
      expect(response).to be_successful

      comment.reload
      expect(comment.text).to eq(text)
    end

    it "doesn't update the comment if the body is empty" do
      original_text = comment.text

      patch :update, params: { id: comment.id, text: "" }, xhr: true
      expect(response).to be_successful

      comment.reload
      expect(comment.text).to eq(original_text)
    end
  end

  shared_examples "comment deleter" do
    it "deletes the comment" do
      expect {
        delete :destroy, params: { id: comment.id }, xhr: true
      }.to change(Comment, :count).by(-1)
    end
  end

  let!(:user)       { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:admin )     { create(:admin_user) }
  let!(:subject)    { create(:subject) }
  let!(:challenge)  { create(:challenge, subject: subject) }
  let!(:solution)   { create(:solution, user: user, challenge: challenge, status: :completed, completed_at: 1.week.ago) }
  let!(:comment)    { create(:comment, user: user, commentable: challenge) }

  describe "POST #create" do
    context "when not signed in" do
      it "redirects to login" do
        post :create, params: { commentable_resource: "challenges", id: challenge.id, text: "hola mundo" }, xhr: true
        expect(response).to redirect_to :login
      end
    end

    context "when signed in" do
      before { controller.sign_in(user) }

      it "creates the comment if body is not empty" do
        expect {
          post :create, params: { commentable_resource: "challenges", id: challenge.id, text: "hola mundo" }, xhr: true
        }.to change(Comment, :count).by(1)
      end

      it "doesn't create the comment if body is empty" do
        expect {
          post :create, params: { commentable_resource: "challenges", id: challenge.id, text: "" }, xhr: true
        }.to_not change(Comment, :count)
      end
    end
  end

  describe "GET #edit" do
    context "when not signed in" do
      it "redirects to login" do
        get :edit, params: { id: comment.id }
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
        expect { get :edit, params: { id: comment.id }, xhr: true }.to raise_error(ActionController::RoutingError)
      end
    end
  end

  describe "PATCH #update" do
    context "when not signed in" do
      it "redirects to login" do
        patch :update, params: { id: comment.id, text: "hola mundo" }, xhr: true
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
          patch :update, params: { id: comment.id, text: "nuevo texto" }, xhr: true
        }.to raise_error(ActionController::RoutingError)

        comment.reload
        expect(comment.text).to eq(original_text)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when not signed in" do
      it "redirects to login" do
        delete :destroy, params: { id: comment.id }
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
          delete :destroy, params: { id: comment.id }, xhr: true
        }.to raise_error(ActionController::RoutingError)

        comment.reload
        expect(comment.text).to eq(original_text)
      end
    end
  end

  describe "GET #response_to" do

  end
end
