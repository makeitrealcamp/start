class LessonsController < ApplicationController
  before_action :private_access

  # GET /courses/:course_id/resources/:resource_id/sections/:section_id/lessons/:id
  def show
    @lesson = Lesson.find(params[:id])
    @course = @lesson.section.resource.course
    @resource = @lesson.section.resource
    if @lesson.free_preview? || current_user.has_access_to?(@lesson.resource)
      render :show
    else
      flash[:error] = "Debes suscribirte para tener acceso a todas las lecciones"
      redirect_to course_resource_path(@lesson.resource.course,@lesson.resource)
    end
  end

  # POST /courses/:course_id/resources/:resource_id/sections/:section_id/lessons/:id/complete
  def complete
    @lesson = Lesson.find(params[:id])

    if @lesson.free_preview? || current_user.has_access_to?(@lesson.resource)
      unless current_user.has_completed_lesson?(@lesson)
        LessonCompletion.create(user: current_user,lesson: @lesson)
      end
    end

    redirect_to next_path(@lesson)
  end

  private
    def next_path(lesson)
      next_lesson = lesson.next(current_user)
      if next_lesson
        course_resource_section_lesson_path(next_lesson.section.resource.course, next_lesson.section.resource,
        next_lesson.section, next_lesson)
      else
        course_resource_path(lesson.resource.course, lesson.resource)
      end
    end
end
