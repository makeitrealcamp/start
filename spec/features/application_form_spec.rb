require 'rails_helper'

RSpec.feature "Challenges", type: :feature do

  scenario "signup analytics script", js: true do
    visit thanks_path
    analytics_mock = page.evaluate_script('window.signUpAnalyticsMock');
    expect(analytics_mock).to eq(true)
  end

end
