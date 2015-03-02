class CoursesController < ApplicationController
  before_action :private_access

  def show
    @course = Course.find(params[:id])
  end
end
