class PhasesController < ApplicationController
  before_action :private_access
  before_action :admin_access, except:[:index,:show]
  before_action :set_phase, only: [:show,:edit,:update]

  def index
    @phases = Phase.for(current_user)
  end

  def show
    @courses = @phase.courses.for(current_user)
  end

  def new
    @phase = Phase.new
  end

  def create
    @phase = Phase.new(phase_params)
    if @phase.save
      flash[:notice] = "Fase creada"
      redirect_to phase_path(@phase)
    else
      render :new
    end
  end

  def edit

  end

  def update
    if @phase.update(phase_params)
      flash[:notice] = "Fase actualizada"
      redirect_to phase_path(@phase)
    else
      render :edit
    end
  end

  def update_position
    @content = Phase.update(params[:id], row_position: params[:position])
    render nothing: true, status: 200
  end

  protected

  def phase_params
    params.require(:phase).permit(:name,:description,:published,:color)
  end

  def set_phase
    @phase = Phase.friendly.find(params[:id])
  end
end
