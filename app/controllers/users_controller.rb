class UsersController < ApplicationController
  before_action :public_access, only: [:new, :create]


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

  private
    def user_params
      params.require(:user).permit(:email, :password)
    end

    def activate_params
      params.require(:user).permit(:first_name, :optimism, :motivation, :mindset)
    end
end
