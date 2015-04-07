# enconding: UTF-8
class PasswordsController < ApplicationController
  before_action :private_access

  def edit
  end

  def update
    current_user.errors[:password] << "Por favor ingresa una contraseña" if params[:password].blank?
    current_user.update(user_params) if current_user.errors.empty?
  end

  private
    def user_params
      params.permit(:password, :password_confirmation)
    end
end
