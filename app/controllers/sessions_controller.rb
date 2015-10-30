# encoding: UTF-8
class SessionsController < ApplicationController
  before_action :public_access, only: [:new, :create]

  def new
  end

  def create_with_omniauth
    if env['omniauth.auth'].info.email.blank?
      url_omniauth_failure("No pudimos obtener el email de #{env['omniauth.auth'].provider.capitalize}. Por favor habilítalo")
    elsif user = AuthProvider.omniauth(env['omniauth.auth'])
      redirect_user_free and return if user.free_account?
      redirect_user_with_status_created and return if user.created?
      sign_in(user)
      redirect_to signed_in_root_path
    else
      redirect_to login_path, flash: { error:
        %Q( Para ingresar a la plataforma debes ser estudiante de Make it Real.
          Visita <a href="http://www.makeitreal.camp">makeitreal.camp</a> para más información)
        }
    end
  end

  def omniauth_failure
    url_omniauth_failure("Es necesario que autorices los permisos para poder ingresar a Make it Real.")
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  private

    def url_omniauth_failure(message)
      redirect_to login_path, flash: { error: message }
    end

    def redirect_user_free
      redirect_to root_path, notice: %Q(
          Make it Real ya no está disponible para usuarios gratuitos.
          Si quieres ingresar al programa haz click en el botón ¡Aplica ahora!)

    end

    def redirect_user_with_status_created
      redirect_to login_path, notice: %Q(
          Debes Activar tu cuenta, el link de activación fue enviado a su correo electronico,
          si no es asi por favor vuelvalo a pedir)
    end
end
