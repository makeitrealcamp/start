class ProjectSolutionsController < ApplicationController
  before_action :private_access
  before_action :paid_access
  before_action :set_project

  # GET /subjects/:subject_id/projects/:project_id/project_solutions/:id
  def show
    @project_solution = ProjectSolution.find(params[:id])
    if !current_user.is_admin? && !current_user.has_completed_project?(@project)
      flash[:notice] = "Debes publicar tu solución para ver las soluciones de la comunidad."
      redirect_to subject_project_path(@project.subject,@project)
    end
  end

  # GET /subjects/:subject_id/projects/:project_id/project_solutions
  def index
    if current_user.is_admin? || current_user.has_completed_project?(@project)
      @own_project_solution = @project.project_solutions.find_by_user_id(current_user.id)
      @project_solutions = @project.project_solutions.where.not(user_id: current_user.id)
    else
      flash[:notice] = "Debes publicar tu solución para ver las soluciones de la comunidad."
      redirect_to subject_project_path(@project.subject,@project)
    end
  end

  # POST /subjects/:subject_id/projects/:project_id/project_solutions
  def create
    @project_solution = @project.project_solutions.build(project_solution_params)
    @project_solution.user = current_user

    if @project_solution.save
      flash[:notice] = "Tu solución ha sido publicada, ahora ayuda a los demás con tu opinión"
      redirect_to subject_project_project_solutions_path(@project.subject,@project)
    else
      render "projects/show"
    end
  end

  def update
    @project_solution = current_user.project_solutions.find(params[:id])

    if @project_solution.update(project_solution_params)
      flash[:notice] = "Tu solución ha sido actualizada"
      redirect_to subject_project_project_solutions_path(@project.subject,@project)
    else
      render "projects/show"
    end
  end

  def request_revision
    @project_solution = ProjectSolution.find(params[:id])
    @project_solution.pending_review!
    redirect_to request.referer
  end

  protected

  def set_project
    @project = Project.find(params[:project_id])
  end

  def project_solution_params
    params.require(:project_solution).permit(:repository,:url,:summary)
  end

end
