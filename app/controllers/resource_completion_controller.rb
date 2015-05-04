class ResourceCompletionController < ApplicationController
  before_action :private_access

  def create
    @resource = Resource.friendly.find(params[:resource_id])
    unless @resource.users.include? current_user
      @resource.users << current_user
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
      if current_user.finished?(course) && resource.last?
        next_course = course.next 
        if next_course
          if current_user.progress(next_course) == 0
            flash[:notice] = "<strong>¡Felicitaciones!</strong> Has terminado #{course.name}. Esta aventura continúa con #{next_course.name}"
          end
          course.next
        else
          course
        end
      else
        next_resource = resource.next
        next_resource ? [course, next_resource] : course
      end
    end

end