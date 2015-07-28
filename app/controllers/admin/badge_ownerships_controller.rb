class Admin::BadgeOwnershipsController < ApplicationController
  before_action :admin_access

  def new
    user = User.find(params[:user_id])
    @badge_ownership = BadgeOwnership.new(user: user)

    @unassigned_badges = Badge.manually.where.not(id: user.badges)
  end

  def create
    @badge_ownership = BadgeOwnership.create(badge_ownership_params)
  end

  private
    def badge_ownership_params
      params.require(:badge_ownership).permit(:user_id, :badge_id)
    end
end
