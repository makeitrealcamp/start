class ProjectsController < ApplicationController
  before_action :private_access
  before_action :admin_access, except:[:show]
  before_action :paid_access, only:[:show]
  before_action :set_project, only: [:show,:edit,:update,:destroy]

  # GET /courses/:course_id/projects/:id
  def show
    @project_solution = @project.project_solutions.find_or_initialize_by(user_id: current_user.id)
    ActivityLog.create(user: current_user, activity: @project, description: "Entró a ver #{@project.to_html_description}")
  end

  # GET /courses/:course_id/projects/new
  def new
    course = Course.friendly.find(params[:course_id])
    @project = course.projects.new
  end

  # POST /courses/:course_id/projects

  def create
    @course = Course.friendly.find(params[:course_id])
    @project = @course.projects.new(project_params)

    if @project.save
      redirect_to @course, anchor: "projects"
    else
      render :new
    end
  end

  # GET /courses/:course_id/projects/:id/edit
  def edit
  end

  # PATCH /courses/:course_id/projects/:id
  def update
    @project = Project.find(params[:id])
    if @project.update(project_params)
      redirect_to course_project_path(@project.course,@project), anchor: "projects", notice: "Proyecto actualizado"
    else
      render :edit
    end
  end

  # DELETE /courses/:course_id/projects/:id
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
