class ResourceCompletionController < ApplicationController
  before_action :private_access

  def create
    @resource = Resource.friendly.find(params[:resource_id])
    if @resource.resource_completions.where(user: current_user).blank?
      @resource.resource_completions.create(user_id: current_user.id)
    end

    respond_to do |format|
      format.html { redirect_to next_path(@resource) }
      format.js
    end
  end

  def destroy
    @resource = Resource.friendly.find(params[:resource_id])
    ResourceCompletion.where(resource_id: @resource.id, user_id: current_user.id).delete_all
  end

  private
    def next_path(resource)
      course = resource.course
      if current_user.finished?(course) && resource.last?
        next_course = course.next
        if next_course
          if current_user.stats.progress_by_course(next_course) == 0
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
