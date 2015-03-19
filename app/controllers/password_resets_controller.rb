class PasswordResetsController < ApplicationController
  before_action :public_access

  def new
  end

  def create
    @errors = []
    @errors << "Por favor digite un correo electrónico" if params[:email].blank?
    user = User.find_by_email(params[:email]) unless params[:email].blank?

    if user
      user.send_password_reset
    else
      @errors << "El correo electrónico no existe en la base de datos"
    end
  end


  def edit
    @user = User.where(["settings -> 'password_reset_token' = '#{params[:t]}'"]).first
    if @user.settings['password_reset_sent_at'] < 2.hours.ago
      redirect_to login_path, flash:{error: "La página ya no se encuentra disponible"}
    end
  end

  def update
    @user = User.where(["settings -> 'password_reset_token' = '#{params[:t]}'"]).first
    @user.errors[:password] << "Por favor ingresa una contraseña" if params[:user][:password].blank?
    if @user.settings['password_reset_sent_at'] < 2.hours.ago
      redirect_to new_password_resets_path, flash:{error: "La página ya no se encuentra disponible"}
    elsif @user.errors.empty? && @user.update(user_params)
      redirect_to login_path, flash: {notice: "la contraseña se ha restablecido correctamente"}
    else
      render :edit
    end
  end

  private
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

end
