class Admin::ProjectsController < ApplicationController
  before_action :admin_access
  before_action :set_project, only: [:edit,:update,:destroy]

  # GET admin/subjects/:subject_id/projects/index
  def index
    @paths = Path.all
    @projects = Project.published
    if !params[:subject_id].blank?
      @projects = @projects.where(subject_id: params[:subject_id])
    else
      @projects = @projects.order("updated_at DESC")
    end

    @projects = @projects.limit(100)
  end

  # GET admin/subjects/:subject_id/projects/new
  def new
    subject = Subject.friendly.find(params[:subject_id])
    @project = subject.projects.new
  end

  # POST admin/subjects/:subject_id/projects
  def create
    @subject = Subject.friendly.find(params[:subject_id])
    @project = @subject.projects.new(project_params)

    if @project.save
      redirect_to admin_projects_path
    else
      render :new
    end
  end

  # GET admin/subjects/:subject_id/projects/:id/edit
  def edit
    @projects = Project.published
  end

  # PATCH admin/subjects/:subject_id/projects/:id
  def update
    @project = Project.find(params[:id])
    if @project.update(project_params)
      redirect_to admin_projects_path, notice: "Proyecto actualizado"
    else
      render :edit
    end
  end

  # DELETE admin/subjects/:subject_id/projects/:id
  def destroy
    @project.destroy
  end

  def update_position
    project = Project.find(params[:id])

    position = params[:positions].find_index(project.id.to_s)
    project.update_attribute :row_position, position
    head :ok
  end

  protected

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :explanation_text, :explanation_video_url, :published, :row_position, :difficulty_bonus)
  end

end
