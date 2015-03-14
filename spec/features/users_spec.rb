require 'rails_helper'

RSpec.feature "Users", type: :feature do

  let(:user){create(:user)}
  let(:admin){create(:admin)}

  context 'when accessed as user' do
    scenario "should redirect to the login  when is not logged in" do
      visit users_path
      expect(current_path).to eq login_path
    end

    scenario "should not allow access" do
      login(user)
      expect { visit users_path }.to raise_error ActionController::RoutingError
    end

    scenario "should not show link of admin", js: true do
      login(user)
      wait_for_ajax
      expect(page).not_to have_content('Admin')
      expect(current_path).to eq dashboard_path
    end
  end

  context 'when accessed as admin' do
    scenario "show list users", js: true do
      login(admin)
      visit users_path
      wait_for_ajax
      expect(current_path).to eq users_path
    end

    scenario "show link of users", js: true do
      login(admin)
      wait_for_ajax
      expect(all('a', text: 'Admin').count).to eq 1
      expect(current_path).to eq dashboard_path
    end
  end
end
