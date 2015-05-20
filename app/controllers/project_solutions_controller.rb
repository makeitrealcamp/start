class ProjectSolutionsController < ApplicationController

  before_action :set_project

  # GET /courses/:course_id/projects/:project_id/project_solutions/:id
  def show
    @project_solution = ProjectSolution.find(params[:id])
    if !current_user.is_admin? && !current_user.has_completed_project?(@project)
      flash[:notice] = "Debes publicar tu solución para ver las soluciones de la comunidad."
      redirect_to course_project_path(@project)
    end
  end

  # GET /courses/:course_id/projects/:project_id/project_solutions
  def index
    if current_user.is_admin? || current_user.has_completed_project?(@project)
      @project_solutions = @project.project_solutions.where.not(user_id: current_user.id)
    else
      flash[:notice] = "Debes publicar tu solución para ver las soluciones de la comunidad."
      redirect_to course_project_path(@project)
    end
  end

  # POST /courses/:course_id/projects/:project_id/project_solutions
  def create
    @project_solution = @project.project_solutions.build(project_solution_params)
    @project_solution.user = current_user

    if @project_solution.save
      flash[:notice] = "Tu solución ha sido publicada, ahora ayuda a los demás con tu opinión"
      redirect_to course_project_project_solutions_path(@project.course,@project)
    else
      render "projects/show"
    end
  end

  def update
    @project_solution = current_user.project_solutions.find(params[:id])

    if @project_solution.update(project_solution_params)
      flash[:notice] = "Tu solución ha sido actualizada"
      redirect_to course_project_project_solutions_path(@project.course,@project)
    else
      render "projects/show"
    end
  end

  protected

  def set_project
    @project = Project.find(params[:project_id])
  end

  def project_solution_params
    params.require(:project_solution).permit(:repository,:url,:summary)
  end

end
