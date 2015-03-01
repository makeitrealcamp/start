# encoding: UTF-8
class SessionsController < ApplicationController
  before_action :public_access, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      sign_in(user)
      redirect_to dashboard_path
    else
      redirect_to login_path, flash: { error: "Credenciales Inválidas" }
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
