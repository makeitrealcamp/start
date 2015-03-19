class UserMailer < ApplicationMailer

  def password_reset(user)
    @user = user
    mail to: @user.email, subject: "Se ha reseteado la contraseña"
  end
end
