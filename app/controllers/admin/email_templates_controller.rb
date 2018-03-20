class Admin::EmailTemplatesController < ApplicationController
  before_action :admin_access

  def index
    @templates = EmailTemplate.all
    @templates
  end

  def new
    @template = EmailTemplate.new
  end

  def create
    @template = EmailTemplate.create(email_params)
  end
 
  def show
    @template = EmailTemplate.find(params[:id])
  end

  def destroy
    template = EmailTemplate.find(params[:id])
    template.destroy

    redirect_to admin_email_templates_path
  end

  private
  def email_params
    params.require(:email_template).permit(:title, :subject, :body)
  end
end 
