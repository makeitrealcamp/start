class PagesController < ApplicationController
  before_action :public_access, except: [:handbook]

  def home
    @user = User.new
  end

  def handbook
  end

end
