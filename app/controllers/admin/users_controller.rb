class Admin::UsersController < ApplicationController
  before_action :admin_access

  def index
    @users ||= User.all

    if params[:account_type]
      @users = @users.where(account_type: params[:account_type])
    end

    @users = @users.order('created_at DESC')
      .paginate(page: params[:page], per_page: 15)

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

    Rails.application.routes.url_helpers.admin_users_path(params_clone)
  end
end
