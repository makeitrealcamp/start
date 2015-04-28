# encoding: UTF-8
class SessionsController < ApplicationController
  before_action :public_access, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      sign_in(user)
      redirect_to courses_path
    else
      redirect_to login_path, flash: { error: "Credenciales Inválidas" }
    end
  end

  def create_with_omniauth
    user = AuthProvider.omniauth(env['omniauth.auth'])
    if user
      sign_in(user)
      redirect_to courses_path
    else
     redirect_to login_path, flash: { error: "Credenciales Inválidas" }
    end
  end

  def omniauth_failure
    redirect_to login_path, flash: {error: "Necesitamos que nos de los permisos para acceder a la aplicación"}
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
