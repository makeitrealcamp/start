class LessonsController < ApplicationController
  before_action :private_access
  before_action :admin_access, except:[:show]

  # GET /courses/:course_id/resources/:resource_id/sections/:section_id/lessons/:id
  def show
    @lesson = Lesson.find(params[:id])
    if @lesson.free_preview? || current_user.has_access_to?(@lesson.resource)
      render :show
    else
      flash[:error] = "Debes suscribirte para tener acceso a todas las lecciones"
      redirect_to course_resource_path(@lesson.resource.course,@lesson.resource)
    end
  end

end
