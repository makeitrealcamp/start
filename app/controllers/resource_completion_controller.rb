class ResourceCompletionController < ApplicationController
  before_action :private_access

  def create
    @resource = Resource.friendly.find(params[:resource_id])
    unless @resource.users.include? current_user
      @resource.users << current_user
      KMTS.record(current_user.email, 'Completed Resource', { id: @resource.id, name: @resource.title })
    end

    respond_to do |format|
      format.html { redirect_to next_path(@resource) }
      format.js
    end
  end

  def destroy
    @resource = Resource.friendly.find(params[:resource_id])
    @resource.users.delete(current_user)
  end

  private
    def next_path(resource)
      course = resource.course
      if current_user.finished?(course)
        course.next || course
      else
        next_resource = resource.next
        next_resource ? [course, next_resource] : course
      end
    end

end