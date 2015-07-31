# enconding: UTF-8
class PasswordsController < ApplicationController
  before_action :private_access

  def edit
  end

  def update
    @password_change = PasswordChangeForm.new(password_change_params.merge(user: current_user))
    @password_change.save
  end

  private
    def password_change_params
      params.require(:password_change).permit(:password,:password_confirmation)
    end
end
