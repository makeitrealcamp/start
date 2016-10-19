class Admin::SubjectsController < ApplicationController
  before_action :admin_access

  def index
    @subjects = Subject.all
  end

  def update_position
    @subject = Subject.update(params[:id], row_position: params[:position])
    render nothing: true, status: 200
  end
end
