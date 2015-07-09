class PairProgrammingTimesController < ApplicationController
  before_action :private_access
  before_action :set_pair_programming_time, only: [:edit,:update,:destroy]

  def index
    @own_pair_programming_times = current_user.pair_programming_times
  end

  def new
    @pair_programming_time = current_user.pair_programming_times.build
  end

  def create
    @pair_programming_time = current_user.pair_programming_times.build(pair_programming_time_params)
    if @pair_programming_time.save
      render :create
    else
      render :new
    end
  end

  def edit
    owner_or_admin_access
  end

  def update
    owner_or_admin_access
    if @pair_programming_time.update(pair_programming_time_params)
      render :update
    else
      render :edit
    end
  end

  def destroy
    owner_or_admin_access
    @pair_programming_time.destroy
  end

  protected

  def pair_programming_time_params
    params.require(:pair_programming_time).permit(
      :day,:start_time_hour,:start_time_minute,:end_time_hour,
      :end_time_minute,:time_zone)
  end

  def set_pair_programming_time
    @pair_programming_time = PairProgrammingTime.find(params[:id])
  end

  def owner_or_admin_access
    is_admin = signed_in? && current_user.is_admin?
    is_owner_of_time = signed_in? && @pair_programming_time.user.id == current_user.id
    if(!is_admin && !is_owner_of_time)
      raise ActionController::RoutingError.new('Not Found')
    end
  end

end
