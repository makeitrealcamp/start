class Admin::ChallengesController < ApplicationController
  before_action :admin_access

  def index
    @paths = Path.all
    @challenges = Challenge.published
    if !params[:subject_id].blank?
      @challenges = @challenges.where(subject_id: params[:subject_id])
    else
      @challenges = @challenges.order("updated_at DESC")
    end

    @challenges = @challenges.limit(100)
  end
end
