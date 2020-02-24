require 'rails_helper'

RSpec.describe "Subjects management" do
  let(:admin) { create(:admin) }
  let(:path) { user.paths.published.first }
  let(:phase) { path.phases.first }

  scenario "creates a new subject" do
    login(admin)
    visit admin_subjects_path
    click_link 'Nuevo Tema'

    expect {
      fill_in 'subject_name', with: Faker::Commerce.product_name
      fill_in 'subject_description', with: Faker::Lorem.sentence
      fill_in 'subject_excerpt', with: Faker::Lorem.paragraph
      fill_in 'subject_time_estimate', with: "#{Faker::Number.digit} horas"
      click_button 'Crear Subject'
    }.to change(Subject, :count).by 1

    subject = Subject.last
    expect(subject).not_to be_nil
    expect(current_path).to eq subject_path(subject)
    expect(page).to have_content "El tema ha sido creado exitosamente"
  end

  scenario "edits a subject" do
    subject = create(:subject)

    login(admin)
    visit edit_subject_path(subject)

    name = Faker::Commerce.product_name
    description = Faker::Lorem.sentence
    excerpt = Faker::Lorem.paragraph
    time_estimate = "#{Faker::Number.digit} horas"

    fill_in 'subject_name', with: name
    fill_in 'subject_description', with: description
    fill_in 'subject_excerpt', with: excerpt
    fill_in 'subject_time_estimate', with: time_estimate
    click_button 'Actualizar Subject'

    subject.reload
    expect(subject.name).to eq name
    expect(subject.description).to eq description
    expect(subject.excerpt).to eq excerpt
    expect(subject.time_estimate).to eq time_estimate
    expect(page).to have_content 'El tema ha sido actualizado exitosamente'
  end
end
