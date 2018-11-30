require 'rails_helper'

RSpec.feature "top_applicant", type: :feature do
  let(:admin) { create(:admin) }
  let!(:applicant) { create(:top_applicant) }

  scenario "admin can lists and filters top applicants", js: true do
    login(admin)
    visit admin_top_applicants_path

    expect(page.all("table.table tr").count).to eq(TopApplicant.count)

    query = applicant.first_name[0..3]
    fill_in "search-input", with: query
    find("input#search-input").send_keys(:enter) # submit form

    expect(page.all("table.table tr").count).to eq(1)
    within :css, "table.table" do
      expect(page).to have_content(query)
    end
  end

  scenario "admin can add a note to an applicant", js: true do
    login(admin)
    visit admin_top_applicants_path

    find("#applicant-#{applicant.id} .cell-action a").click

    fill_in "activity-value", with: "Esta es la primera nota del día"
    click_on "Agregar Nota"

    within :css, ".activities" do
      expect(page).to have_content("Esta es la primera nota del día")
    end

    applicant.reload
    expect(applicant.note_activities.count).to eq(1)
  end

  scenario "admin can change the status of an applicant", js: true do
    login(admin)
    visit admin_top_applicants_path

    find("#applicant-#{applicant.id} .cell-action a").click

    click_on "Cambiar Estado"
    select "Aceptado", from: "change_status_applicant_activity_to_status"
    fill_in "change_status_applicant_activity_comment", with: "Status changed to test send"
    within :css, "#change-status-modal" do
      click_on "Cambiar Estado"
    end
    expect(page).to have_no_css("#change-status-modal")

    expect(TopApplicant.find(applicant.id).status).to eq("accepted")
  end

  scenario "admin can send an email to an applicant", js: true do
    ActionMailer::Base.deliveries.clear

    create(:email_template)

    login(admin)

    visit admin_top_applicant_path(applicant)
    click_on "Enviar Email"
    expect(page).to have_css("#send-email-modal")

    sleep 0.5 # hack to wait for the animation
    select "Plantilla 1", from: "email_template"
    # expect(page).to have_content("Citado a entrevista de inglés")
    click_on "Enviar"
    expect(page).to have_no_css("#send-email-modal")

    email = ActionMailer::Base.deliveries
    expect(email.count).to eq(1)
  end

  scenario "admin can create and edit an email template", js: true do
    ActionMailer::Base.deliveries.clear

    template = create(:email_template)

    login(admin)
    visit admin_email_templates_path

    click_on "Nueva Plantilla"
    expect(page).to have_css("#email-template-modal")

    expect {
      fill_in "email_template_title", with: "Plantilla 2"
      fill_in "email_template_subject", with: "Citado a entrevista de inglés"
      fill_in "email_template_body", with: "Cita con Juan Gomez el día viernes 9:00 COL"
      click_on "Guardar Plantilla"
      expect(page).to have_no_css("#email-template-modal")
    }.to change(EmailTemplate, :count).by 1

    visit admin_email_templates_path

    within "#template-#{template.id}" do
      click_on "Editar"
    end
    expect(page).to have_css("#email-template-modal")

    expect {
      fill_in "email_template_title", with: "Recordatorio"
      fill_in "email_template_subject", with: "En pocos días comienzas"
      fill_in "email_template_body", with: "Cita con Jefferson Bernal"
      click_on "Guardar Plantilla"
      expect(page).to have_no_css("#email-template-modal")
    }.to change(EmailTemplate, :count).by 0
  end
end
