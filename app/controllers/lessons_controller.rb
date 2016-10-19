class LessonsController < ApplicationController
  before_action :private_access
  before_action :admin_access, except: [:show,:complete]

  def new
    @section = Section.find(params[:section_id])
    @lesson = @section.lessons.new
  end

  def create
    @section = Section.find(params[:section_id])
    @lesson = @section.lessons.new(lesson_params)
    if @lesson.save
      redirect_to subject_resource_path(@lesson.resource.subject, @lesson.resource), notice: "La Lección  <strong>#{@lesson.name}</strong> ha sido creado"
    else
      render :new
    end
  end

  # GET /subjects/:subject_id/resources/:resource_id/sections/:section_id/lessons/:id
  def show
    @lesson = Lesson.find(params[:id])
    @subject = @lesson.section.resource.subject
    @resource = @lesson.section.resource
    if @lesson.free_preview? || current_user.has_access_to?(@lesson.resource)
      render :show
    else
      flash[:error] = "Debes suscribirte para tener acceso a todas las lecciones"
      redirect_to subject_resource_path(@lesson.resource.subject,@lesson.resource)
    end
  end

  def edit
    @lesson = Lesson.find(params[:id])
    @section = Section.find(params[:section_id])
  end

  def update
    @lesson = Lesson.find(params[:id])
    @section = Section.find(params[:section_id])
    if @lesson && @lesson.update(lesson_params)
      redirect_to subject_resource_path(@lesson.resource.subject, @lesson.resource), notice: "La Lección  <strong>#{@lesson.name}</strong> ha sido actualizado"
    else
      render :edit
    end
  end

  # POST /subjects/:subject_id/resources/:resource_id/sections/:section_id/lessons/:id/complete
  def complete
    @lesson = Lesson.find(params[:id])
    unless current_user.has_completed_lesson?(@lesson)
      LessonCompletion.create(user: current_user,lesson: @lesson)
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
      params.require(:lesson).permit(:name, :video_url, :description, :info, :section_id, :free_preview, :video_duration)
    end

    def next_path(lesson)
      next_lesson = lesson.next(current_user)
      if next_lesson
        subject_resource_section_lesson_path(next_lesson.section.resource.subject, next_lesson.section.resource, next_lesson.section, next_lesson)
      else
        subject_resource_path(lesson.resource.subject, lesson.resource)
      end
    end
end
