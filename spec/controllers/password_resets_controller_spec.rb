require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do
  render_views

  describe "GET #new" do
    it "responds with status code 200" do
      get :new, xhr: true
      expect(response).to have_http_status(:ok)
    end

    it "renders template" do
      get :new, xhr: true
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    it "sends the reset email to user with password access" do
      user = create(:user_password)
      expect {
        post :create, params: { password_reset_request: { email: user.email } }, xhr: true
      }.to change { ActionMailer::Base.deliveries.count }.by(1)

      email = ActionMailer::Base.deliveries.last
      user.reload
      expect(email.body.raw_source).to include(edit_password_reset_path(token: user.password_reset_token))
    end

    it "updates the reset token attributes of the user" do
      user = create(:user_password)
      expect(user.password_reset_token).to be_nil
      expect(user.password_reset_sent_at).to be_nil

      post :create, params: { password_reset_request: { email: user.email } }, xhr: true

      user.reload
      expect(user.password_reset_token).to_not be_nil
      expect(user.password_reset_sent_at).to_not be_nil
    end
  end

  describe "GET #edit" do
    it "renders template if the token is valid" do
      user = create(:user_password)
      user.send_password_reset

      get :edit, params: { token: user.password_reset_token }
      expect(response).to have_http_status(:ok)
      expect(response).to render_template :edit
    end

    it "redirects to login if the token is invalid" do
      get :edit, params: { token: "invalid_token" }
      expect(response).to redirect_to(login_path)
    end

    it "redirects to login if the token expired" do
      user = create(:user_password)
      user.send_password_reset
      user.update!(password_reset_sent_at: 2.days.ago)

      get :edit, params: { token: user.password_reset_token }
      expect(response).to redirect_to(login_path)
    end
  end

  describe "PATCH #update" do
    it "updates the password if token is valid" do
      user = create(:user_password)
      user.send_password_reset

      patch :update, params: { password_reset: { token: user.password_reset_token, password: "test12345", password_confirmation: "test12345" } }
      expect(response).to redirect_to(login_path)

      user.reload
      expect(user.password_digest).to_not be_nil
    end

    it "renders the same form if password is empty" do
      user = create(:user_password)
      user.send_password_reset

      patch :update, params: { password_reset: { token: user.password_reset_token, password: "", password_confirmation: "test12345" } }
      expect(response).to render_template :edit
    end
  end
end
