class PairProgrammingTimesController < ApplicationController
  before_action :private_access
  before_action :set_pair_programming_time, only: [:edit,:update,:destroy]
  before_action :set_time_zone

  def index
    @own_pair_programming_times = current_user.pair_programming_times.sort{ |a,b| a.start_time <=> b.start_time }
    @all_times = PairProgrammingTime.where.not(user_id: current_user.id).sort{ |a,b| a.start_time <=> b.start_time }
    calc_matched_times
  end

  def new
    @pair_programming_time = current_user.pair_programming_times.build
  end

  def create
    @pair_programming_time = current_user.pair_programming_times.build(pair_programming_time_params)
    if @pair_programming_time.save
      calc_matched_times
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
      calc_matched_times
      render :update
    else
      render :edit
    end
  end

  def destroy
    owner_or_admin_access
    @pair_programming_time.destroy
    calc_matched_times
  end

  protected

  def pair_programming_time_params
    params.require(:pair_programming_time).permit(
      :day,:start_time_hour,:start_time_minute,:duration_in_minutes,:time_zone
    )
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

  def calc_matched_times
    @matched_times = PairProgrammingTime.match_times_for(current_user).sort{ |a,b| a.start_time <=> b.start_time }
  end

  def set_time_zone
    @time_zone = params[:time_zone] || "Bogota"
  end
end
