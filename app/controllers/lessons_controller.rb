class LessonsController < ApplicationController
  before_action :private_access
  before_action :admin_access, except:[:show]

  # GET /courses/:course_id/resources/:resource_id/sections/:section_id/lessons/:id
  def show
    @lesson = Lesson.find(params[:id])
    if @lesson.free_preview? || current_user.is_enrolled_in?(@lesson.resource)
      render :show
    else
      flash[:error] = "Debes suscribirte al curso para tener acceso todas las lecciones"
      redirect_to course_resource_path(@lesson.resource.course,@lesson.resource)
    end
  end

end
