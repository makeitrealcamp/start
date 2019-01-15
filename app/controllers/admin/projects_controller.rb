class Admin::ProjectsController < ApplicationController
  before_action :admin_access

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

end
