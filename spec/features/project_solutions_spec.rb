require 'rails_helper'

RSpec.feature "ProjectSolutions", type: :feature do
  let(:user) { create(:user) }
  let(:subject) { create(:subject) }
  let(:project) { create(:project, subject: subject)}

  scenario "lists projects solutions" do
    create(:project_solution, user: user, project: project)

    user1 = create(:user)
    create(:project_solution, user: user1, project: project, url: nil)

    login(user)

    visit subject_project_project_solutions_path(subject, project)

    all(:css, ".project-solution-box").first do
      expect(page).to have_selector '.fa-globe'
      find(find_link(project_solution.url)[:href]).to eq project_solution.url
    end

    all(:css, ".project-solution-box").last do
      expect(page).not_to have_selector '.fa-globe'
    end
  end

  scenario "shows solution in markdown format" do
    solution = create(:project_solution, user: user, project: project)

    login(user)
    visit subject_project_project_solutions_path(subject, project)

    all(:css, ".project-solution-box").first do
      expect(page).to have_content(markdown solution.summary)
    end
  end

  scenario "shows solution with url" do
    solution = create(:project_solution, user: user, project: project)

    login(user)
    visit subject_project_project_solution_path(subject, project, solution)

    expect(page).to have_selector '.fa-globe'
    expect(find_link(solution.url)[:href]).to eq solution.url
  end
end
