class SectionsController < ApplicationController
  before_action :admin_access, only: [:create, :update, :destroy]


  def create
    @resource = Resource.friendly.find(params[:resource_id])
    @section = @resource.sections.create(title: params[:title])
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
    if params[:commit] == "Guardar"
      @section.update(title: params[:title])
      @index = params[:index]
    end
  end
end
