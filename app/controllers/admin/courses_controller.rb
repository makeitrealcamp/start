class Admin::CoursesController < ApplicationController
  before_action :admin_access

  def index
    @courses = Course.all
  end

  def update_position
    @course = Course.update(params[:id], row_position: params[:position])
    render nothing: true, status: 200
  end
end
