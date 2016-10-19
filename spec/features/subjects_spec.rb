require 'rails_helper'

RSpec.feature "Subjects", type: :feature do
  let(:user) { create(:user_with_path) }
  let!(:subject) { create(:subject_with_phase) }

  scenario "shows subject", js: true do
    login(user)

    visit subjects_path
    find(:css, "[data-id='#{subject.friendly_id}']").click

    expect(current_path).to eq subject_path(subject)
  end


end
