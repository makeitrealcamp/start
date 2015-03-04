class ResourceCompletionController < ApplicationController
  before_action :private_access

  def create
    @resource = Resource.find(params[:resource_id])
    @resource.users << current_user
  end

  def destroy
    @resource = Resource.find(params[:resource_id])
    @resource.users.delete(current_user)
  end

end