# encoding: UTF-8
class SessionsController < ApplicationController
  before_action :public_access, only: [:new, :create_with_omniauth]
 

  def new
    render layout: "pages"
  end



  def create_with_omniauth
    if env['omniauth.auth'].info.email.blank?
      url_omniauth_failure("No pudimos obtener el email de #{env['omniauth.auth'].provider.capitalize}. Por favor habilítalo")
    elsif user = AuthProvider.omniauth(env['omniauth.auth'])
      redirect_free_user and return if user.free_account?
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

end
