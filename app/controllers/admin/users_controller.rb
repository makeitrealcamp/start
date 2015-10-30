class Admin::UsersController < ApplicationController
  before_action :admin_access

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.subscriptions.create
      @user.send_activate_mail
    end
  end

  def index
    @users ||= User.all

    if params[:q]
      @q = params[:q]
      @users = @users.where("email like ?","%#{params[:q]}%")
    end

    if params[:account_type]
      @users = @users.where(account_type: params[:account_type])
    end

    @users = @users.order('created_at DESC')
      .paginate(page: params[:page], per_page: 200)

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

  def show
    @user = User.find(params[:id])
    @courses = Course.all
    resources_ids =  @user.resource_completions.collect(&:resource_id)
    @resources = Resource.find(resources_ids).group_by(&:course)
  end

  protected
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

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :gender, :nickname, :account_type)
    end
end
