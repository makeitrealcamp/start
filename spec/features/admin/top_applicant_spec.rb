require 'rails_helper'

RSpec.feature "top_applicant", type: :feature do
  let(:admin) { create(:admin_user) }
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
    sleep 0.5

    find("#applicant-#{applicant.id} .cell-action a").click

    click_on "Cambiar Estado"
    select "Aceptado", from: "change_status_applicant_activity_to_status"
    fill_in "change_status_applicant_activity_comment", with: "Status changed to test send"
    within :css, "#change-status-modal" do
      click_on "Cambiar Estado"
    end
    expect(page).to have_no_css("#change-status-modal")

    expect(TopApplicant.find(applicant.id).status).to eq("accepted")

    click_on "Cambiar Estado"
    sleep 0.5 # hack to wait for the animation
    expect(page).to have_no_css("#change_status_applicant_activity_rejected_reason")
    select "Rechazado", from: "change_status_applicant_activity_to_status"
    expect(page).to have_css("#change_status_applicant_activity_rejected_reason")
    fill_in "change_status_applicant_activity_comment", with: "Rejected status"
    select "Respuestas superficiales", from: "change_status_applicant_activity_rejected_reason"
    within :css, "#change-status-modal" do
      click_on "Cambiar Estado"
    end
    expect(page).to have_no_css("#change-status-modal")

    expect(TopApplicant.find(applicant.id).status).to eq("rejected")

    click_on "Cambiar Estado"
    sleep 0.5 # hack to wait for the animation
    expect(page).to have_no_css("#change_status_applicant_activity_second_interview_substate")
    select "Segunda entrevista", from: "change_status_applicant_activity_to_status"
    expect(page).to have_css("#change_status_applicant_activity_second_interview_substate")
    fill_in "change_status_applicant_activity_comment", with: "Second interview status"
    select "Pendiente", from: "change_status_applicant_activity_second_interview_substate"
    within :css, "#change-status-modal" do
      click_on "Cambiar Estado"
    end
    expect(page).to have_no_css("#change-status-modal")

    expect(TopApplicant.find(applicant.id).status).to eq("second_interview_held")
  end

  scenario "admin can edit the info of an applicant", js: true do
    login(admin)
    visit admin_top_applicants_path

    find("#applicant-#{applicant.id} .cell-action a").click

    click_on "Editar"

    fill_in "applicant_info_prev_salary", with: "1000"
    fill_in "applicant_info_new_salary", with: "1000"
    fill_in "applicant_info_company", with: "Nueva compañía"
    fill_in "applicant_info_start_date", with: "01/01/2022"
    fill_in "applicant_info_contract_type", with: "Término indefinido"
    select "5", from: "applicant_info_socioeconomic_level"
    fill_in "applicant_info_referred_by", with: "Jane Doe"

    within :css, "#applicant-modal" do
      click_on "Guardar Aplicación"
    end
    expect(page).to have_no_css("#applicant-modal")
    expect(page).to have_content("Salario Anterior:")
    expect(TopApplicant.find(applicant.id).info).to include("prev_salary"=>"1000", "new_salary"=>"1000", "company"=>"Nueva compañía", "start_date"=>"01/01/2022", "contract_type"=>"Término indefinido", "socioeconomic_level"=>"5", "referred_by"=>"Jane Doe")

    click_on "Editar"
    sleep 0.5 # hack to wait for the animation
    expect(page).to have_field("applicant_info_prev_salary", with: "1000")
    expect(page).to have_field("applicant_info_new_salary", with: "1000")
    expect(page).to have_field("applicant_info_company", with: "Nueva compañía")
    expect(page).to have_field("applicant_info_start_date", with: "01/01/2022")
    expect(page).to have_field("applicant_info_contract_type", with: "Término indefinido")
    expect(page).to have_field("applicant_info_socioeconomic_level", with: "5")
    expect(page).to have_field("applicant_info_referred_by", with: "Jane Doe")

    fill_in "applicant_info_prev_salary", with: ""
    fill_in "applicant_info_new_salary", with: ""
    fill_in "applicant_info_company", with: ""
    fill_in "applicant_info_start_date", with: ""
    fill_in "applicant_info_contract_type", with: ""
    select "", from: "applicant_info_socioeconomic_level"
    fill_in "applicant_info_referred_by", with: ""

    within :css, "#applicant-modal" do
      click_on "Guardar Aplicación"
    end
    expect(page).to have_no_css("#applicant-modal")
    expect(page).not_to have_content("Salario Anterior:")
    expect(page).not_to have_content("Salario nuevo:")
    expect(page).not_to have_content("Empresa:")
    expect(page).not_to have_content("FEcha de inicio:")
    expect(page).not_to have_content("Tipo de contrato:")
    expect(page).not_to have_content("Nivel socioeconomico:")
    expect(page).not_to have_content("Referido por:")


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

  scenario "filter substatus in top applicants lists", js: true do
    login(admin)
    visit admin_top_applicants_path

    find("#applicant-#{applicant.id} .cell-action a").click

    click_on "Cambiar Estado"
    sleep 0.5 # hack to wait for the animation
    select "Rechazado", from: "change_status_applicant_activity_to_status"
    expect(page).to have_css("#change_status_applicant_activity_rejected_reason")
    fill_in "change_status_applicant_activity_comment", with: "Rejected status"
    select "Respuestas superficiales", from: "change_status_applicant_activity_rejected_reason"
    within :css, "#change-status-modal" do
      click_on "Cambiar Estado"
    end
    
    visit admin_top_applicants_path
    sleep 0.5

    expect(page.all("table.table tr").count).to eq(TopApplicant.count)
    expect(page).to have_no_css("#filter_substatus_applicant_activity")
    find("#filter_status_applicant_activity").click
    find("#filter_status_applicant_activity").click_link("Rechazado")
    expect(page).to have_css("#filter_substatus_applicant_activity")
    expect(page.all("table.table tr").count).to eq(1)

    find("#filter_substatus_applicant_activity").click
    find("#filter_substatus_applicant_activity ul").click_link("Inglés muy bajo")
    sleep 0.5
    expect(page.all("table.table tr").count).to eq(0)

    find("#filter_substatus_applicant_activity").click
    find("#filter_substatus_applicant_activity ul").click_link("Respuestas superficiales")
    sleep 0.5
    expect(page.all("table.table tr").count).to eq(1)

    

  end
end
