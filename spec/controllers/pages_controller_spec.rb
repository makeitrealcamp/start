require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  render_views

  describe "GET #top" do
    it "responds with status code 200" do
      get :top_full_and_part_time
      expect(response).to have_http_status(:ok)
    end

    it "renders template" do
      get :top_full_and_part_time
      expect(response).to render_template :top_full_and_part_time
    end
  end

  describe "GET #top" do
    it "responds with status code 200" do
      get :top_full_and_part_time
      expect(response).to have_http_status(:ok)
    end

    it "renders template" do
      get :top_full_and_part_time
      expect(response).to render_template :top_full_and_part_time
    end
  end

  # describe "GET #full_stack_online" do
  #   it "responds with status code 200" do
  #     get :full_stack_online
  #     expect(response).to have_http_status(:ok)
  #   end

  #   it "renders template" do
  #     get :full_stack_online
  #     expect(response).to render_template :full_stack_online
  #   end
  # end

  describe "GET #thanks_online" do
    it "responds with status code 200" do
      get :thanks_online
      expect(response).to have_http_status(:ok)
    end

    it "render template" do
      get :thanks_online
      expect(response).to render_template :thanks_online
    end
  end

  describe "POST #send_web_developer_guide" do
    it "responds with status code 200" do
      post :send_web_developer_guide, params: { first_name: "Pedro", last_name: "Perez", email: "pedro@example.com", goal: "change-career" }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #handbook" do
    it "shows content" do
      fake_content = "fake content"
      expect_any_instance_of(Octokit::Client).to receive(:contents).and_return(fake_content)
      get :handbook
      expect(response.body).to have_content fake_content
    end
  end

  describe "POST #create_lead" do
    it "responds with status 200" do
      request.headers.merge!({ 'Authorization': "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.XbPfbIHMI6arZ3Y922BhjWgQzWXcXNrz0ogtVhfEd2o" })
      post :create_lead, 
          params: { program_name: "QA Tester", convertloop_event: "qa-tester", first_name: "Pedro", last_name: "Perez", email: "pedro@example.com" }
      expect(response).to have_http_status(:ok)
    end
  end
end
