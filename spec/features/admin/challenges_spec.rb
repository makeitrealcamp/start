require 'rails_helper'

RSpec.feature "Challenges management", type: :feature do
  let(:admin) { create(:admin_user) }
  let(:subject) { create(:subject) }
  let(:challenge) { create(:challenge, subject: subject) }

  scenario "updates a challenge" do
    login(admin)
    visit edit_admin_subject_challenge_path(subject, challenge)

    click_button 'Editar Reto'
    expect(current_path).to eq subject_challenge_path(subject, challenge)
  end
end
