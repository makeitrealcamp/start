class CoursesController < ApplicationController
  before_action :private_access
  before_action :admin_access, only:[:edit, :update]

  def show
    @course = Course.friendly.find(params[:id])
  end

  def edit
    @course = Course.friendly.find(params[:id])
  end

  def update
    @course = Course.friendly.update(params[:id], course_params)
    redirect_to @course, notice: "El curso ha sido actualizado"
  end

  private
    def course_params
      params.require(:course).permit(:name, :description, :excerpt, :abstract)
    end
end
