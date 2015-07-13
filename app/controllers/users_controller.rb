class UsersController < ApplicationController
  before_action :private_access, except: [:new, :create, :profile]
  before_action :public_access, only: [:new, :create]

#  def new
#    redirect_to application_form_path
#    # @user = User.new
#  end
#
#  def create
#    @user = User.create(user_params)
#    if @user.valid?
#      sign_in(@user)
#      redirect_to signed_in_root_path
#    else
#      render :new
#    end
#  end

  def activate
    begin
      gender = Gendered::Name.new(activate_params[:first_name]).guess!
    rescue SocketError => e
      gender = :male
    end

    current_user.update(activate_params.merge(gender: gender, status: User.statuses[:active], activated_at: Time.current))
  end

  def edit
    @user = User.find(params[:id])
    owner_or_admin_access(@user,current_user)
  end

  def update
    @user = User.find(params[:id])
    owner_or_admin_access(@user,current_user)
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

  # /users/:id/profile
  def profile
    @user = User.find(params[:id])
    @is_own_profile = (@user == current_user)
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :mobile_number, :birthday, :has_public_profile)
    end

    def activate_params
      params.require(:user).permit(:first_name, :optimism, :motivation, :mindset, :experience)
    end
end
