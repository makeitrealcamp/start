class ResourceCompletionController < ApplicationController
  before_action :private_access

  def create
    @resource = Resource.friendly.find(params[:resource_id])
    @subject = @resource.subject
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
    @subject = @resource.subject
    ResourceCompletion.where(resource_id: @resource.id, user_id: current_user.id).delete_all
  end

  private
    def next_path(resource)
      subject = resource.subject
      if current_user.finished?(subject) && resource.last?
        next_subject = subject.next
        if next_subject
          if current_user.stats.progress_by_subject(next_subject) == 0
            flash[:notice] = "<strong>¡Felicitaciones!</strong> Has terminado #{subject.name}. Esta aventura continúa con #{next_subject.name}"
          end
          subject.next
        else
          subject
        end
      else
        next_resource = resource.next
        next_resource ? [subject, next_resource] : subject
      end
    end

end
