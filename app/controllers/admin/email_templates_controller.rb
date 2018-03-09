class Admin::EmailTemplatesController < ApplicationController
  def index
    @template= EmailTemplate.new
    @templates= EmailTemplate.all
  end

  def create
    @template = EmailTemplate.create(email_params)
    redirect_to admin_email_templates_path
  end

  def show
    @template = EmailTemplate.find(params[:id])
  end

  def destroy
    @template = EmailTemplate.find(params[:id]) 
    @template.destroy
    redirect_to admin_email_templates_path
  end

  private
  def email_params
    params.require(:email_template).permit(:title, :subject, :body)
  end
end
