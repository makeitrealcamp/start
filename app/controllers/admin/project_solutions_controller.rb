class Admin::ProjectSolutionsController < ApplicationController
  before_action :admin_access

  def index
    @solutions = ProjectSolution.all
    @q = {}
    if ["pending_review","reviewed"].include? params[:status]
      @q[:status] = params[:status]
      @solutions = @solutions.send(@q[:status])
    end
    if((@q[:project] = params[:project]) && (!@q[:project].strip.blank?))
      @solutions = @solutions.where(project_id: @q[:project])
    end
    if((@q[:user] = params[:user]) && (!@q[:user].strip.blank?))
      @solutions = @solutions.where(user_id: User.search(@q[:user]))
    end
  end

  def assign_points
    @project_solution = ProjectSolution.find(params[:id])
    @user = @project_solution.user

    @user.points.create(
      course: @project_solution.project.course,
      points:assign_points_params[:points],
      pointable: @project_solution.project
    )

    @project_solution.status = ProjectSolution.statuses[:reviewed]
    @project_solution.save

    redirect_to request.referer
  end

  private

  def assign_points_params
    params.require(:point).permit(:points)
  end

end
