class SectionsController < ApplicationController
  before_action :admin_access, only: [:create, :update, :destroy]

  def new
    @resource = Resource.friendly.find(params[:resource_id])
    @section = @resource.sections.new
  end

  def create
    @resource = Resource.friendly.find(params[:resource_id])
    @section = @resource.sections.create(section_params)
  end

  def destroy
    @section = Section.find(params[:id])
    @section.destroy
  end

  def edit
    @section = Section.find(params[:id])
    @index = params[:index]
  end

  def update
    @section = Section.find(params[:id])
    @section.update(section_params)
    @index = params[:index]
  end

  private

   def section_params
    params.require(:section).permit(:title)
   end
end
