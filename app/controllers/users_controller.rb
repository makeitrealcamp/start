class UsersController < ApplicationController
  before_action :private_access, except: [:profile, :activate_form, :activate]

  def activate_form
    @activate_user = ActivateUserForm.new(user: current_user)
  end

  def activate
    @activate_user = ActivateUserForm.new(activate_user_params.merge(user: current_user))
    
    if @activate_user.save
      redirect_to signed_in_root_path, flash: { notice: "¡Felicitaciones! Has activado tu cuenta de Make it Real. Ingresa a la plataforma y descubre lo que tenemos preparado para ti." }
    else
      render :activate_form
    end
  end

  def edit
    @user = User.find(params[:id])
    owner_or_admin_access(@user, @user)
  end

  def update
    @user = User.find(params[:id])
    @is_own_profile = (@user == current_user)
    owner_or_admin_access(@user, @user)
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
      params.require(:user).permit(:first_name, :mobile_number, :birthday,
        :has_public_profile, :github_username, :nickname, :gender
      )
    end
    def activate_user_params
      params.require(:activate_user).permit(:first_name, :mobile_number, :birthday, :github_username, :nickname, :gender
      )
    end
end
