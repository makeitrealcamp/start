class UsersController < ApplicationController
  before_action :public_access, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.valid?
      sign_in(@user)
      redirect_to dashboard_path
    else
      render :new
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :password)
    end
end
