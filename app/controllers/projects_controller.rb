class ProjectsController < ApplicationController
  before_action :private_access
  before_action :paid_access


  # GET /subjects/:subject_id/projects/:id
  def show
    @project = Project.find(params[:id])
    @project_solution = @project.project_solutions.find_or_initialize_by(user_id: current_user.id)
    @project.subject
  end

end
