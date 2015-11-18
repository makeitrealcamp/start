class Admin::DashboardController < ApplicationController
  before_action :admin_access
  
  def index
  end
end
