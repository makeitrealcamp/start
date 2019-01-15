class ProjectsController < ApplicationController
  before_action :private_access
  before_action :admin_access, except:[:show]
  before_action :paid_access, only:[:show]
  before_action :set_project, only: [:show,:edit,:update,:destroy]

  # GET /subjects/:subject_id/projects/:id
  def show
    @project_solution = @project.project_solutions.find_or_initialize_by(user_id: current_user.id)
  end

  # GET /subjects/:subject_id/projects/new
  def new
    subject = Subject.friendly.find(params[:subject_id])
    @project = subject.projects.new
  end

  # POST /subjects/:subject_id/projects
  def create
    @subject = Subject.friendly.find(params[:subject_id])
    @project = @subject.projects.new(project_params)

    if @project.save
      redirect_to admin_projects_path
    else
      render :new
    end
  end

  # GET /subjects/:subject_id/projects/:id/edit
  def edit
  end

  # PATCH /subjects/:subject_id/projects/:id
  def update
    @project = Project.find(params[:id])
    if @project.update(project_params)
      redirect_to admin_projects_path, notice: "Proyecto actualizado"
    else
      render :edit
    end
  end

  # DELETE /subjects/:subject_id/projects/:id
  def destroy
    @project.destroy
  end

  def update_position
    @project = Project.update(params[:id], row_position: params[:position])
    head :ok
  end

  protected

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(
      :name,
      :explanation_text,
      :explanation_video_url,
      :published,
      :row_position,
      :difficulty_bonus
    )
  end
end
