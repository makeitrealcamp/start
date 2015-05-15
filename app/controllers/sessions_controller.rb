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
    if env['omniauth.auth'].info.email.blank?
      url_omniauth_failure("No pudimos obtener el email de #{env['omniauth.auth'].provider.capitalize}. Por favor habilítalo o regístrate usando tu email y contraseña")
    else
      user = AuthProvider.omniauth(env['omniauth.auth'])
      if user
        sign_in(user)
        redirect_to courses_path
      else
       redirect_to login_path, flash: { error: "Credenciales Inválidas" }
      end
    end
  end

  def omniauth_failure
    url_omniauth_failure("Es necesario que autorices los permisos para poder ingresar a Make it Real. También puedes regístrate con email y contraseña.")
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  private

  def url_omniauth_failure(message)
    redirect_to signup_path, flash: { error: message }
  end
end
