require 'rails_helper'

RSpec.feature "Applicant Test", type: :feature do
  scenario "TOP applicant can submit test", js: true do
    applicant = create(:top_applicant)

    visit top_program_challenge_path(uid: "wrong!")
    expect(page).to have_content("¡Lo sentimos! No encontramos el registro asociado")

    visit top_program_challenge_path(uid: applicant.uid)
    expect(page).not_to have_content("¡Lo sentimos! No encontramos el registro asociado")

    fill_in "code", with: "test"
    click_on "Validar Código"

    expect(page.current_path).to eq(top_program_challenge_path)
    expect(page).to have_content("Código inválido")

    fill_in "code", with: Base64.strict_encode64(applicant.uid)
    click_on "Validar Código"

    expect(page.current_path).to eq(top_program_test_path)

    click_on "Enviar"
    expect(page).to have_content("no puede estar en blanco")

    execute_script("topProgramTestView.a1.setValue('something')")
    execute_script("topProgramTestView.a2.setValue('something')")
    execute_script("topProgramTestView.a3.setValue('something')")

    click_on "Enviar"
    expect(page.current_path).to eq(top_program_submitted_path)

    test = TopApplicantTest.where(applicant: applicant)
    expect(test).not_to be_nil
  end

  scenario "innovate applicant can submit test", js: true do
    applicant = create(:innovate_applicant)

    visit innovate_program_challenge_path(uid: "wrong!")
    expect(page).to have_content("¡Lo sentimos! No encontramos el registro asociado")

    visit innovate_program_challenge_path(uid: applicant.uid)
    expect(page).not_to have_content("¡Lo sentimos! No encontramos el registro asociado")

    fill_in "code", with: "test"
    click_on "Validar Código"

    expect(page.current_path).to eq(innovate_program_challenge_path)
    expect(page).to have_content("Código inválido")

    fill_in "code", with: Base64.strict_encode64(applicant.uid)
    click_on "Validar Código"

    expect(page.current_path).to eq(innovate_program_test_path)

    click_on "Enviar"
    expect(page).to have_content("no puede estar en blanco")

    execute_script("innovateProgramTestView.a1.setValue('something')")
    execute_script("innovateProgramTestView.a2.setValue('something')")
    execute_script("innovateProgramTestView.a3.setValue('something')")

    click_on "Enviar"
    expect(page.current_path).to eq(innovate_program_submitted_path)

    test = InnovateApplicantTest.where(applicant: applicant)
    expect(test).not_to be_nil
  end
end
