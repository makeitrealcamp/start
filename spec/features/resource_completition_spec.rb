require 'rails_helper'

RSpec.feature "Resource completion", type: :feature do
  let!(:user) { create(:user) }
  let!(:subject) { create(:subject) }

  context "when user completes a resource and there are more resources", js: true do
    scenario "redirects to next resource" do
      resource = create(:resource, subject: subject)
      next_resource = create(:resource, subject: subject, row_position: :last)

      login(user)

      visit subject_resource_path(subject, resource)
      click_link 'Completar y Continuar'

      expect(current_path).to eq subject_resource_path(subject, next_resource)
    end
  end

  context "when user completes last resource but haven`t finished subject" do
    scenario "redirects to same subject", js: true do
      resource = create(:resource, subject: subject)
      challenge = create(:challenge, subject: subject)

      login(user)

      visit subject_resource_path(resource.subject, resource)
      click_link 'Completar y Continuar'

      expect(current_path).to eq subject_path(resource.subject)
    end
  end

  context "when user completes last resource (and subject) and there are more subjects" do
    scenario "redirects to next subject", js: true do
      current_subject = create(:subject, row_position: :last)
      resource = create(:resource, subject: current_subject)
      next_subject = create(:subject, row_position: :last)

      login(user)

      visit subject_resource_path(resource.subject, resource)
      click_link 'Completar y Continuar'

      expect(current_path).to eq subject_path(next_subject)
    end
  end

  context "when user completes last resource (and subject) and there are no more subjects" do
    scenario "redirects to subject page", js: true do
      resource = create(:resource)
      login(user)

      visit subject_resource_path(resource.subject, resource)
      click_link 'Completar y Continuar'

      expect(current_path).to eq subject_path(resource.subject)
    end
  end

  context "when user completes a subject but it's not the last resource", js: true do
    scenario "redirects to next resource" do
      resource = create(:resource, subject: subject)
      next_resource = create(:resource, subject: subject, row_position: :last)
      user.resource_completions.create(resource: next_resource) # user has already completed next resource

      login(user)

      visit subject_resource_path(subject, resource)
      click_link 'Completar y Continuar'

      expect(current_path).to eq subject_resource_path(subject, next_resource)
    end
  end

  scenario "marks a resource as completed", js: true do
    resource = create(:resource, subject: subject)

    login(user)

    visit subject_path(subject)
    click_link 'Recursos'
    all(:css, '.resource-additional .glyphicon-ok-circle').first.click

    expect(page).to have_selector '.resource-additional .completed'
    expect(current_path).to eq subject_path(subject)
    expect(user.resources.exists?(resource.id)).to eq true
  end

  scenario "unmarks a resource as completed", js: true do
    resource = create(:resource, subject: subject)
    create(:resource_completion, resource: resource, user: user)

    login(user)

    visit subject_path(subject)
    click_link 'Recursos'
    all(:css, '.resource-additional .glyphicon-ok-circle').first.click

    expect(page).not_to have_selector '.resource-additional .completed'
    expect(current_path).to eq subject_path(subject)
    expect(user.resources.exists?(resource.id)).to eq false
  end
end
