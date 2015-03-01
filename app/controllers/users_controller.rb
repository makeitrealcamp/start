class UsersController < ApplicationController
  def create
    user = User.create(user_params)
    sign_in(user)
    redirect_to dashboard_path
  end

  private
    def user_params
      params.require(:user).permit(:email, :password)
    end
end
