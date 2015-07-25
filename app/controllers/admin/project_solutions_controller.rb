class Admin::ProjectSolutionsController < ApplicationController
  before_action :admin_access


  def assign_points
    @project_solution = ProjectSolution.find(params[:id])
    @user = @project_solution.user

    @user.points.create(course: @project_solution.project.course, points:assign_points_params[:points], pointable: @project_solution.project)

    @project_solution.status = ProjectSolution.statuses[:reviewed]
    @project_solution.save

    redirect_to request.referer
  end

  private

  def assign_points_params
    params.require(:project_solution).permit(:points)
  end

end
