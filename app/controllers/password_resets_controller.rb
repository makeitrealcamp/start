class PasswordResetsController < ApplicationController
  before_action :public_access

  def new
  end

  def create
    @reset_request = PasswordResetRequestForm.new(password_reset_request_params)
    if @reset_request.valid?
      user = User.find_by_email(@reset_request.email.downcase)
      user.send_password_reset
    end
  end

  def edit
    token = params[:token]
    user = User.where("settings -> 'password_reset_token' = ?",token).take
    if !user
      redirect_to login_onsite_path, flash: { error: "El token no es válido. Solicita uno nuevamente haciendo click en 'Olvidé mi contraseña'" }
      return
    end

    if user.has_valid_password_reset_token?
      @password_reset = PasswordResetForm.new(token: token)
    else
      redirect_to login_onsite_path, flash: { error: "El token de restablecimiento de contraseña ha vencido. Solicita uno nuevo. Solicita uno nuevamente haciendo click en 'Olvidé mi contraseña'" }
    end
  end

  def update
    @password_reset = PasswordResetForm.new(password_reset_params)
    if @password_reset.save
      redirect_to login_onsite_path, flash: { notice: "Ok, ahora puedes ingresar con tu nueva contraseña." }
    else
      render :edit
    end
  end

  private
    def password_reset_request_params
      params.require(:password_reset_request).permit(:email)
    end

    def password_reset_params
      params.require(:password_reset).permit(:password, :password_confirmation, :token)
    end
end
