class UserMailer < ApplicationMailer

  def password_reset(user)
    @user = user
    mail to: @user.email, subject: "Reestablecer Contraseña"
  end

  def inscription_info(user)
    @user = user
    mail to: @user.email, subject: "¿Quieres aprender a crear tus propias aplicaciones Web?"
  end
end
