class UserMailer < ApplicationMailer

  def password_reset(user)
    @user = user
    mail to: @user.email, subject: "Hemos reestablecido tu contraseña"
  end
end
