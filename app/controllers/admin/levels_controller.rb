class Admin::LevelsController < ApplicationController
  before_action :admin_access

  def index
    @levels = Level.all
  end

  def new
    @level = Level.new
  end

  def create
    @level = Level.new(level_params)

    if @level.save
      redirect_to admin_levels_path, notice: "El nivel  <strong>#{@level.name}</strong> ha sido creado"
    else
      render :new
    end
  end

  def edit
    @level = Level.find(params[:id])
  end

  def update
    @level = Level.find(params[:id])
    if @level && @level.update(level_params)
      redirect_to admin_badges_path, notice: "El nivel  <strong>#{@level.name}</strong> ha sido actualizado"
    else
      render :edit
    end
  end

  def destroy
    @level = Level.find(params[:id])
    @level.destroy

    redirect_to admin_levels_path
  end

  private

    def level_params
      params.require(:level).permit(:name, :required_points, :image_url)
    end

end

#  id              :integer          not null, primary key
#  name            :string
#  required_points :integer
#  image_url       :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
