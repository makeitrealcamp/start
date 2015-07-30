class UsersController < ApplicationController
  before_action :private_access, except: [:new, :create, :profile, :activate_form, :activate]
  before_action :public_access, only: [:new, :create, :activate_form, :activate]

  def activate_form
    token = params[:token]
    @user = User.created.where("settings -> 'password_reset_token' = ? ", token).take!

    if @user.password_reset_sent_at < 2.days.ago
      redirect_to login_path, flash: { error: "Tu link de activación ha expirado." }
    end
  end

  def activate
    token = params[:token]
    @user = User.created.where("settings -> 'password_reset_token' = ?",token).take!

# TODO: pasar tooooooda esta lógica al modelo
    if @user.password_reset_sent_at < 2.days.ago
      redirect_to login_path, error: "Tu link de activación ha expirado."
    end
    user_attrs = user_params.merge(status: User.statuses[:active],activated_at: Time.current)

    @user.errors[:password] << "es un campo requerido" if user_params[:password].blank?

    if @user.errors.empty? && @user.update(user_attrs)
      @user.update(password_reset_token: nil,password_reset_sent_at: nil)
      @user.subscriptions.create
      if Rails.env.development?
        SubscriptionsMailer.welcome_mail(@user).deliver_now
        SubscriptionsMailer.welcome_hangout(@user).deliver_now
      else
        SubscriptionsMailer.welcome_mail(@user).deliver_now
        SubscriptionsMailer.welcome_hangout(@user).deliver_later!(wait: 24.hours)
      end
# TODO: pasar tooooooda esta lógica al modelo ^^
      redirect_to login_path, notice: "¡Felicitaciones! Has activado tu cuenta de Make it Real. Ingresa a la plataforma y descubre lo que tenemos preparado para ti."
    else
      render :activate_form
    end
  end

  def edit
    @user = User.find(params[:id])
    owner_or_admin_access(@user,@user)
  end

  def update
    @user = User.find(params[:id])
    @is_own_profile = (@user == current_user)
    owner_or_admin_access(@user,@user)
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to signed_in_root_path, flash: { notice: "Tu perfil se ha actualizado" } }
        format.js { render :update }
      else
        format.html { render :edit }
        format.js { render :update }
      end
    end

  end

  def send_inscription_info
    @first_request = true if current_user.info_requested_at.nil?
    current_user.send_inscription_info
  end

  # /u/:nickname
  def profile
    @user = User.find_by_nickname!(params[:nickname])
    owner_or_admin_access(@user,@user) unless @user.has_public_profile?
    @is_own_profile = (@user == current_user)
  end

  private
    def user_params
      params.require(:user).permit(
        :password, :password_confirmation, :first_name, :mobile_number, :birthday,
        :has_public_profile, :github_username, :nickname, :gender
      )
    end
end
