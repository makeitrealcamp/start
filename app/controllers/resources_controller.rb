class ResourcesController < ApplicationController
  before_action :private_access
  before_action :admin_access, except: [:show]

  def new
    course = Course.friendly.find(params[:course_id])
    @resource = course.resources.new
  end

  def create
    @course = Course.friendly.find(params[:course_id])
    @resource = @course.resources.new(resource_params)

    if @resource.save
      redirect_to @course
    else
      render :new
    end
  end

  def show
    @resource = Resource.friendly.find(params[:id])
  end

  def edit
    @resource = Resource.friendly.find(params[:id])
  end

  def update
    @resource = Resource.friendly.find(params[:id])
    if @resource.update(resource_params)
      redirect_to @resource.course
    else
      render :edit
    end
  end

  def destroy
    @resource = Resource.friendly.find(params[:id])
    @resource.destroy
  end

  def update_position
    @resource = Resource.update(params[:id], row_position: params[:position])
    render nothing: true, status: 200
  end

  def show
  end

  private

   def resource_params
     params.require(:resource).permit(:title, :description, :type, :url, :content, :time_estimate, :published)
   end

end
