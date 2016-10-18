class ResourcesController < ApplicationController
  before_action :private_access
  before_action :admin_access, except: [:show, :open]

  def new
    @subject = Subject.friendly.find(params[:subject_id])
    @resource = @subject.resources.new
  end

  def create
    @subject = Subject.friendly.find(params[:subject_id])
    @resource = @subject.resources.new(resource_params)

    if @resource.save
      redirect_to subject_resource_path(@resource.subject, @resource)
    else
      render :new
    end
  end

  def show
    @resource = Resource.friendly.find(params[:id])

    if @resource.markdown?
      description = "Abrió el recurso interno #{@resource.to_html_description}"
      ActivityLog.create(name: "viewed-markdown-resource", user: current_user, activity: @resource, description: description)
    end
  end

  def edit
    @resource = Resource.friendly.find(params[:id])
  end

  def update
    @resource = Resource.friendly.find(params[:id])
    if @resource.update(resource_params)
      redirect_to subject_resource_path(@resource.subject, @resource), notice: "Recurso actualizado"
    else
      render :edit
    end
  end

  def destroy
    @resource = Resource.friendly.find(params[:id])
    @resource.destroy
  end

  def update_position
    Resource.update(params[:id], row_position: params[:position])
    head :ok
  end

  # used to open an external resource and log the activity
  def open
    resource = Resource.friendly.find(params[:id])
    if resource.url?
      description = "Abrió el recurso externo #{resource.to_html_description}"
      ActivityLog.create(name: "opened-external-resource", user: current_user, activity: resource, description: description)

      redirect_to resource.url
    else
      # in case someone tries to open another resource
      redirect_to subject_resource_path(resource.subject, resource)
    end
  end

  private
    def resource_params
      params.require(:resource).permit(
        :title, :description, :type, :url, :content, :time_estimate,
        :published, :video_url, :category, :own
      )
   end

end
