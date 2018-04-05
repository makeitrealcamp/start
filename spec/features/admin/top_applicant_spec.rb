require 'rails_helper'

RSpec.feature "top_applicant", type: :feature do
  scenario "List and filter Top applicants", js: true do
    user = User.create(email:"pepito@one.com",first_name:"Pepito", last_name:"gomez",password:"1234566", level_id: $2,  status: :active, account_type: :admin_account, access_type: :password)
    top_applicant = create(:top_applicant)
    login_password(user)
    first("a[href$='#']").click
    find("a[href$='/admin/top_applicants']").click
    sleep 2
    page.all("table.table tr").count.should == TopApplicant.count
    query = "#{top_applicant.first_name}"
    fill_in "search-input", with: query
    find("input#search-input").send_keys(:enter)
    page.all("table.table tr").each do |tr|
    tr.text[query].should == query
    end
  end

  scenario "Allow to leave a comment in top applicant application", js: true do
    user = User.create(email:"pepito@one.com",first_name:"Pepito", last_name:"gomez",password:"1234566", level_id: $2,  status: :active, account_type: :admin_account, access_type: :password)
    top_applicant = create(:top_applicant)
    login_password(user)

    first("a[href$='#']").click
    find("a[href$='/admin/top_applicants']").click
    find("a[href$='/admin/top_applicants/1']").click
    fill_in "note_applicant_activity_body", with: "Esta es la primera nota del día"
    find("input[type='submit']").click
    sleep 2
    applicant = TopApplicant.find(top_applicant.id)
    expect(applicant.note_activities.count).to eq(1)
    sleep 2
  end

  scenario "Allow to change status in top applicant application", js: true do
    user = User.create(email:"pepito@one.com",first_name:"Pepito", last_name:"gomez",password:"1234566", level_id: $2,  status: :active, account_type: :admin_account, access_type: :password)
    top_applicant = create(:top_applicant)
    login_password(user)
    first("a[href$='#']").click
    find("a[href$='/admin/top_applicants']").click
    find("a[href$='/admin/top_applicants/1']").click
    find("a[href$='/admin/top_applicants/1/change_status_applicant_activities/new']").click
    select "Aceptado", :from => "change_status_applicant_activity_to_status"
    fill_in "change_status_applicant_activity_comment", with:"Status changed to test send"
    find("input[type='submit']").click
    sleep 2
    expect(TopApplicant.find(top_applicant.id).status).to eq("accepted")
  end

  scenario "Allow to send an email in top applicant application", js: true do
    ActionMailer::Base.deliveries.clear
    user = User.create(email:"pepito@one.com",first_name:"Pepito", last_name:"gomez",password:"1234566", level_id: $2,  status: :active, account_type: :admin_account, access_type: :password)
    top_applicant = create(:top_applicant)
    login_password(user)
    first("a[href$='#']").click
    find("a[href$='/admin/top_applicants']").click
    find("a[href$='/admin/email_templates']").click
    find("a[href$='/admin/email_templates/new']").click
    fill_in "email_template_title", with: "Plantilla 1 "
    sleep 1
    fill_in "email_template_subject", with: "Citado a entrevista de inglés "
    sleep 1
    fill_in "email_template_body", with: "Cita con Juan Gomez el día viernes 9:00 COL"
    find("input[type='submit'").click
    expect(find("table.table tbody tr")).not_to be_nil
    first("a[href$='#']").click
    find("a[href$='/admin/top_applicants']").click
    find("a[href$='/admin/top_applicants/1']").click
    find("a[href$='/admin/top_applicants/1/email_applicant_activities/new']").click
    sleep 2
    select "Plantilla 1", :from => "email_template"
    sleep 2
    find("input[type='submit']").click
    sleep 2
    email = ActionMailer::Base.deliveries
    expect(email.count).to eq(1)
  end
end
