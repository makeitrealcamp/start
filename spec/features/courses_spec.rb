require 'rails_helper'

RSpec.feature "Courses", type: :feature do
  let(:user) { create(:user_with_path) }
  let!(:course) { create(:course_with_phase) }

  scenario "shows course", js: true do
    login(user)
    
    visit courses_path
    find(:css, "[data-id='#{course.friendly_id}']").click
    
    expect(current_path).to eq course_path(course)
  end

  
end
