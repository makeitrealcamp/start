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
      redirect_to admin_badges_path, notice: "La insignia  <strong>#{@lesson.name}</strong> ha sido creado"
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def delete
  end

  private

    def badge_params
      params.require(:badge).permit(:name, :description, :image_url, :course_id)
    end

end
