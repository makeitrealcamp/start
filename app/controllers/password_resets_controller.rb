class PasswordResetsController < ApplicationController
  before_action :public_access

  def new
  end

  def create
    @reset_request = PasswordResetRequestForm.new(password_reset_request_params)
    if @reset_request.valid?
      user = User.find_by_email(@reset_request.email)
      user.send_password_reset
    end
  end


  def edit
    token = params[:token]
    user = User.where("settings -> 'password_reset_token' = ?",token).take!
    if user.has_valid_password_reset_token?
      @password_reset = PasswordResetForm.new(token: token)
    else
      redirect_to login_path, flash: { error: "El token de restablecimiento de contraseña ha vencido. Solicita uno nuevo." }
    end
  end

  def update
    @password_reset = PasswordResetForm.new(password_reset_params)
    if @password_reset.save
      redirect_to login_path, flash: { notice: "la contraseña se ha restablecido correctamente" }
    else
      render :edit
    end
  end

  private
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def password_reset_request_params
      params.require(:password_reset_request).permit(:email)
    end

    def password_reset_params
      params.require(:password_reset).permit(:password, :password_confirmation, :token)
    end
end
