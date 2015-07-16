require 'rails_helper'

RSpec.feature "Challenges", type: :feature do

  scenario "signup analytics script", js: true do
    visit thanks_path
    analyticsMock = page.evaluate_script('window.signUpAnalyticsMock');
    expect(analyticsMock).to eq(true)
  end

end
