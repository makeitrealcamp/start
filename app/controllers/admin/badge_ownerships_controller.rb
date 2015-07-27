class Admin::BadgeOwnershipsController < ApplicationController
  before_action :admin_access
  
  def new
    user = User.find(params[:user_id])
    @badge_ownership = BadgeOwnership.new(user: user)

    user_ownerships = user.badge_ownerships.map { |badge_ownership| badge_ownership.badge }
    @unassigned_badges = Badge.manually.where.not(id: user_ownerships)
  end

  def create
    @badge_ownership = BadgeOwnership.create(badge_ownership_params)
  end

  private
    def badge_ownership_params
      params.require(:badge_ownership).permit(:user_id, :badge_id)
    end
end
