class UsersController < ApplicationController
  before_action :private_access, except: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.valid?
      sign_in(@user)
      KMTS.record(current_user.email, 'Signed Up')
      redirect_to courses_path
    else
      render :new
    end
  end

  def activate
    gender = Gendered::Name.new(activate_params[:first_name]).guess!
    current_user.update(activate_params.merge(gender: gender, status: User.statuses[:active], activated_at: Time.current))
    KMTS.record(current_user.email, 'Activated')
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to root_path, flash: { notice: "Tu perfil se ha actualizado" }
    else
      render :edit
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :first_name, :mobile_number, :birthday)
    end

    def activate_params
      params.require(:user).permit(:first_name, :optimism, :motivation, :mindset)
    end
end
