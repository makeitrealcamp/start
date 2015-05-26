class LessonsController < ApplicationController
  before_action :private_access
  before_action :admin_access, only: [:edit]

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

  def edit
    @lesson = Lesson.find(params[:id])
  end

  def update
    @lesson = Lesson.find(params[:id])
    if @lesson && @lesson.update(lesson_params)
      redirect_to course_resource_path(@lesson.resource.course, @lesson.resource), notice: "La Lección  <strong>#{@lesson.name}</strong> ha sido actualizado"
    else
      render :edit
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


  def update_position
    lesson = Lesson.update(params[:id], row_position: params[:position])
    head :ok
  end


  def destroy
    @lesson = Lesson.find(params[:id])
    @lesson.destroy
  end

  private

  def lesson_params
    params.require(:lesson).permit(:name, :video_url, :description, :info)
  end

    def next_path(lesson)
      next_lesson = lesson.next(current_user)
      if next_lesson
        course_resource_section_lesson_path(next_lesson.section.resource.course, next_lesson.section.resource, next_lesson.section, next_lesson)
      else
        course_resource_path(lesson.resource.course, lesson.resource)
      end
    end
end
