require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  let!(:user)       { create(:paid_user) }
  let!(:other_user) { create(:paid_user) }
  let!(:admin )     { create(:admin) }
  let!(:course)     { create(:course) }
  let!(:challenge)  { create(:challenge, course: course) }
  let!(:solution)   { create(:solution, user: user, challenge: challenge, status: :completed, completed_at: 1.week.ago) }
  let!(:comment)    { create(:comment, user: user, commentable: challenge) }

  before do
    cookies.delete(:user_id)
  end

  describe "#owner_or_admin_access" do
    before do
      cookies.permanent.signed[:user_id] = admin.id
    end
    context "when user is admin" do
      it "should allow request edition form of any comment" do
        xhr :get, :edit, id: comment.id
        expect(response).to have_http_status(:ok)
      end

      it "should allow edition of any comment" do
        new_text = "new text"
        xhr :patch, :update, id: comment.id, text: new_text

        expect(response).to have_http_status(:ok)
        expect(comment.reload.text).to eq(new_text)
      end

      it "should allow deletion of any comment" do
        xhr :delete, :destroy, id: comment.id

        expect(response).to have_http_status(:ok)
        expect(Comment.find_by_id(comment.id)).to eq(nil)
      end
    end

    context "when user is owner of the comment" do
      before do
        cookies.permanent.signed[:user_id] = user.id
      end
      it "should allow request edition form of any comment" do
        xhr :get, :edit, id: comment.id
        expect(response).to have_http_status(:ok)
      end

      it "should allow edition of any comment" do
        new_text = "new text"
        xhr :patch, :update, id: comment.id, text: new_text

        expect(response).to have_http_status(:ok)
        expect(comment.reload.text).to eq(new_text)
      end

      it "should allow deletion of any comment" do
        xhr :delete, :destroy, id: comment.id

        expect(response).to have_http_status(:ok)
        expect(Comment.find_by_id(comment.id)).to eq(nil)
      end
    end
    context "when user is not owner of the comment" do
      before do
        cookies.permanent.signed[:user_id] = other_user.id
      end
      it "should not allow request edition form of others' comments" do
        expect { xhr :get, :edit, id: comment.id }.to raise_error(ActionController::RoutingError)
      end

      it "should not allow edition of others' comments" do
        new_text = "new text"
        old_text = comment.text
        expect{ xhr :patch, :update, id: comment.id, text: new_text }.to raise_error(ActionController::RoutingError)
        expect(comment.reload.text).to eq(old_text)
      end

      it "should not allow deletion of others' comments" do
        expect{xhr :delete, :destroy, id: comment.id}.to raise_error(ActionController::RoutingError)
        expect(Comment.find_by_id(comment.id)).to eq(comment)
      end
    end

  end

end
