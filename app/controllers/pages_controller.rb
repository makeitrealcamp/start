class PagesController < ApplicationController
  before_action :public_access

  def home
    @user = User.new
  end
end
