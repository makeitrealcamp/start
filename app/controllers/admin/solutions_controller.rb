class Admin::SolutionsController < ApplicationController
  before_action :admin_access

  def index
    @solutions = Solution.evaluated
    if !params[:challenge_id].blank?
      @solutions = @solutions.where(challenge_id: params[:challenge_id])
    else
      @solutions = @solutions.order("updated_at DESC")
    end

    @solutions = @solutions.limit(100)
  end
end