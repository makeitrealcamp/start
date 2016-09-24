# encoding: UTF-8
class SessionsController < ApplicationController
  before_action :public_access, only: [:new, :create_with_omniauth]

  def new
    render layout: "pages"
  end

  def new_onsite
    render layout: "pages"
  end

  def create
    user = User.find_by(email: params[:email])
     if user && user.password? && !user.suspended? && user.password_digest && user.authenticate(params[:password])
       sign_in(user)
       redirect_to signed_in_root_path
     else
       redirect_to login_onsite_path, flash: { error: "No se pudo realizar la autenticación. Revisa tus credenciales e intenta nuevamente. Asegúrate que tu cuenta esté activa y puedas acceder con contraseña. Comunícate con nosotros a info@makeitreal.camp si tienes alguna duda." }
     end
  end

  def create_with_omniauth
    if env['omniauth.auth'].info.email.blank?
      url_omniauth_failure("No pudimos obtener el email de #{env['omniauth.auth'].provider.capitalize}. Por favor habilítalo")
    elsif user = AuthProvider.omniauth(env['omniauth.auth'])
      sign_in(user)
      redirect_to signed_in_root_path
    else
      redirect_to login_path, flash: { error:
        %Q(No se pudo realizar la autenticación. Si aún no eres estudiante de Make it Real
        visita <a href="http://www.makeitreal.camp">makeitreal.camp</a> para conocer nuestros
        programas. De lo contrario comunícate con nosotros a info@makeitreal.camp)
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
