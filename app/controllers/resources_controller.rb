class ResourcesController < ApplicationController
  before_action :private_access
  before_action :admin_access, only:[:new, :create]

  def new
    @course = Course.find(params[:course_id])
    @resource = @course.resources.new
  end

  def create
    @course = Course.find(params[:course_id])
    @resource = @course.resources.new(resource_params)

    if @resource.save
      redirect_to @course
    else
      render :new
    end
  end

  def show
  end

  private

   def resource_params
     params.require(:resource).permit(:title, :description, :type, :url)
   end

end
