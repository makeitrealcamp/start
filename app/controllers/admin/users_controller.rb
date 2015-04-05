class Admin::UsersController < ApplicationController
  before_action :admin_access

  def index
    @users = User.order('created_at DESC')
  end

  def show
    @user = User.find(params[:id])
    @courses = Course.all
  end
end
