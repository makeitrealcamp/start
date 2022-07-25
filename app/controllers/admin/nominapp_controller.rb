class Admin::NominappController < ApplicationController
  before_action :admin_access

  def index
    group = Group.find_by(name: "nominapp")
    @users = group.users
  end

  def show
    group = Group.find_by(name: "nominapp")
    @user = group.users.find(params[:id])
    @subjects = @user.paths.first.subjects
  end
end
