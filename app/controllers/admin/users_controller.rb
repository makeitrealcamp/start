class Admin::UsersController < ApplicationController
  before_action :admin_access

  def index
    @users = User.all

    if params[:q]
      @q = params[:q]
      @users = @users.where("email ilike :q or profile -> 'first_name' ilike :q or profile -> 'last_name' ilike :q", q: "%#{params[:q]}%")
    end

    if params[:account_type]
      @users = @users.where(account_type: params[:account_type])
    end

    @users_count = @users.count

    @users = @users.order('created_at DESC')
      .paginate(page: params[:page], per_page: 20)

    @account_types = User.account_types.map do |type,id|
      account_type = {
        active: false,
        text: type.titlecase,
        id: id,
        url: generate_account_type_url(id)
      }
      if(params[:account_type] && params[:account_type].include?(id.to_s))
        account_type[:active] = true
      end
      account_type
    end
  end

  def new
    @user = User.new
    @user.path_subscriptions.build(path_id: Path.first.id) if Path.first
  end

  def create
    @user = User.new(user_params.merge(status: :created))
    if @user.save
      @user.send_welcome_email
    end
  end

  def resend_activation_email
    user = User.find(params[:id])
    if user && user.created?
      user.send_welcome_email
      redirect_to admin_users_path, notice: "El correo de activación ha sido reenviado a #{user.email}"
    else
      redirect_to admin_users_path, flash: { error: "El usuario no fue encontrado o ya se encuentra activo" }
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
  end

  def show
    @user = User.find(params[:id])
    @courses = Course.all
  end

  private

    def generate_account_type_url(account_type)
      account_types = params[:account_type].nil? ? [] : params[:account_type].clone

      if account_types.include? account_type.to_s
        account_types.delete account_type.to_s
      else
        account_types << account_type.to_s
      end
      params_clone = params.clone.reject { |k| ['action','controller'].include? k }

      params_clone[:account_type] = account_types
      params_clone[:page] = 1
      Rails.application.routes.url_helpers.admin_users_path(params_clone)
    end

    def user_params
      params.require(:user).permit(
        :first_name, :last_name, :email, :gender, :nickname, :account_type,
        :access_type, :status, path_subscriptions_attributes: [:path_id, :id, :_destroy]
      )
    end
end
