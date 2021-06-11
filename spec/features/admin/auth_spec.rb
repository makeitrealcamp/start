require 'rails_helper'

RSpec.feature "Admin Auth", type: :feature do
  context "logs in successfully" do
    scenario "with all permissions" do
      admin = create(:admin)
      visit admin_login_path

      fill_in "email", with: admin.email
      fill_in "password", with: admin.password

      click_on "Ingresar"

      expect(current_path).to eq(admin_root_path)
      within :css, ".navbar-right .admin-dropdown" do
        expect(page).to have_content("Dashboard")
        expect(page).to have_content("Usuarios")
        expect(page).to have_content("Webinars")
      end
    end

    scenario "with limited permissions" do
      admin = create(:admin, permissions: ["innovate_applicants"])
      visit admin_login_path

      fill_in "email", with: admin.email
      fill_in "password", with: admin.password

      click_on "Ingresar"

      expect(current_path).to eq(admin_root_path)
      within :css, ".navbar-right .admin-dropdown" do
        expect(page).to have_content("Aplicaciones Innovate")
        expect(page).not_to have_content("Dashboard")
        expect(page).not_to have_content("Usuarios")
        expect(page).not_to have_content("Webinars")
      end
    end
  end
end
