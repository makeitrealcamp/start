class ProjectsController < ApplicationController
  before_action :private_access
  before_action :admin_access

  def new
  end

  def create
  end

  # GET /courses/:course_id/projects/:id
  def show
    @project = Project.find(params[:id])
  end
end
