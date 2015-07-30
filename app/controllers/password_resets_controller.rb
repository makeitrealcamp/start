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
    @user = User.where(["settings -> 'password_reset_token' = '#{params[:t]}'"]).take
    raise ActionController::RoutingError.new('Not Found') unless @user

    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to login_path, flash: { error: "La página ya no se encuentra disponible" }
    end
  end

  def update
    @user = User.where("settings -> 'password_reset_token' = '#{params[:t]}'").take
    @user.errors[:password] << "Por favor ingresa una contraseña" if user_params[:password].blank?

    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, flash: { error: "La página ya no se encuentra disponible" }
    elsif @user.errors.empty? && @user.update(user_params)
      @user.update(password_reset_token: nil, password_reset_sent_at: nil)
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
end
