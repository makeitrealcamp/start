class CoursesController < ApplicationController
  before_action :private_access

  def show
    @course = Course.find(params[:id])
  end

  def edit
    @course = Course.find(params[:id])
  end

  def update
    @course = Course.update(params[:id], course_params)
    redirect_to @course, notice: "El curso ha sido actualizado"
  end

  private
    def course_params
      params.require(:course).permit(:name, :description, :excerpt, :abstract)
    end
end
