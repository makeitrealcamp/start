class Admin::BadgesController < ApplicationController
  before_action :admin_access

  def index
    @badges = Badge.all
  end

  def new
    @badge = Badge.new
  end

  def create
    @badge = Badge.new(badge_params)

    if @badge.save
      redirect_to admin_badges_path, notice: "La insignia  <strong>#{@badge.name}</strong> ha sido creado"
    else
      render :new
    end
  end

  def edit
    @badge = Badge.find(params[:id])
  end

  def update
    @badge = Badge.find(params[:id])
    if @badge && @badge.update(badge_params)
      redirect_to admin_badges_path, notice: "La insignia  <strong>#{@badge.name}</strong> ha sido actualizada"
    else
      render :edit
    end
  end

  def destroy
    @badge = Badge.find(params[:id])
    @badge.destroy
  end

  private

    def badge_params
      params.require(:badge).permit(:name, :description, :image_url,
      :giving_method, :require_points, :course_id)
    end

end
