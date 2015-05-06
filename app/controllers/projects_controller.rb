class ProjectsController < ApplicationController
  before_action :private_access
  before_action :admin_access

  def new
  end

  def create
  end

end
