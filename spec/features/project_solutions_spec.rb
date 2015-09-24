require 'rails_helper'

RSpec.feature "ProjectSolutions", type: :feature do
  let!(:user) { create(:paid_user) }
  let!(:course) { create(:course) }
  let!(:project) { create(:project, course: course)}
  let!(:project_solution) { create(:project_solution, user: user, project: project) }

  context 'list project solutions' do
    scenario 'project with 2 solutions' do
      user1 = create(:paid_user)
      create(:project_solution, user: user1, project: project, url: nil)

      login(user)
      visit course_project_project_solutions_path(course, project)

      all(:css, ".project-solution-box").first do
        expect(page).to have_selector '.fa-globe'
        find(find_link(project_solution.url)[:href]).to eq project_solution.url
      end

      all(:css, ".project-solution-box").last do
        expect(page).not_to have_selector '.fa-globe'
      end
    end

    scenario 'display markdown format' do
      login(user)
      visit course_project_project_solutions_path(course, project)
      all(:css, ".project-solution-box").first do
        expect(page).to have_content(markdown project_solution.summary)
      end
    end
  end

  context 'show project solution' do
    scenario 'with url' do
      login(user)
      visit course_project_project_solution_path(course, project, project_solution)
      expect(page).to have_selector '.fa-globe'
      expect(find_link(project_solution.url)[:href]).to eq project_solution.url
    end

    scenario 'without url ' do
      project_solution = create(:project_solution, user: user, project: project, url: nil)
      login(user)
      visit course_project_project_solution_path(course, project, project_solution)
      expect(page).not_to have_selector '.fa-globe'
    end

    scenario 'display markdown format' do
      login(user)
      visit course_project_project_solution_path(course, project, project_solution)
      all(:css, ".project-solution-box").first do
        expect(page).to have_content(markdown project_solution.summary)
      end
    end
  end
end
