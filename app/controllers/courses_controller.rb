class CoursesController < ApplicationController
  before_action :private_access
  before_action :admin_access, except:[:index, :show]

  def index
    @paths = current_user.paths
  end

  def show
    @course = Course.friendly.find(params[:id])
    @tab = @course.challenges.count > 0 ? :challenges : :resources
    @tab = params[:tab].to_sym if params[:tab].present?
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)

    if @course.save
      redirect_to @course, notice: "El curso ha sido creado"
    elsif
      render :new
    end
  end

  def edit
    @course = Course.friendly.find(params[:id])
  end

  def update
    @course = Course.friendly.find(params[:id])
    if @course && @course.update(course_params)
      redirect_to @course, notice: "El curso ha sido actualizado"
    else
      render :edit
    end
  end

  def update_position
    @course = Course.update(params[:id], row_position: params[:position])
    head :ok
  end

  private
    def course_params
      params.require(:course).permit(:name, :description, :excerpt, :abstract,
        :time_estimate, :published, :visibility, :phase_id,
        course_phases_attributes: [:phase_id,:id,:_destroy]
        )
    end
end
