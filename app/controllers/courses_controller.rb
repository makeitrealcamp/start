class CoursesController < ApplicationController
  before_action :private_access
  before_action :admin_access, except:[:index, :show]

  QUOTES = [
    { text: "Nuestra mayor debilidad radica en darnos por vencidos. La forma más segura de triunfar es siempre intentarlo una vez más.", author: "Thomas A. Edison" },
    { text: "No importa qué tan lento vayas siempre y cuando no te detengas.", author: "Confucio" },
    { text: "Para poder triunfar, primero debemos creer que podemos.", author: "Og Mandino" },
    { text: "Nunca estás muy viejo para trazar una nueva meta o soñar un nuevo sueño.", author: "C. S. Lewis" },
  ]

  def index
    @quote = QUOTES.sample
    @courses = Course.for(current_user)
    @courses_by_phase = @courses.group_by(&:phase)
  end

  def show
    @course = Course.friendly.find(params[:id])
    @tab = @course.challenges.count > 0 ? :challenges : :resources
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
        :time_estimate, :published, :visibility, :phase)
    end
end
