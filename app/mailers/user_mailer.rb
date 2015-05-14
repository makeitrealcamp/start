class UserMailer < ApplicationMailer

  def password_reset(user)
    @user = user
    mail to: @user.email, subject: "Reestablecer Contraseña"
  end

  def inscription_info(user)
    @user = user
    mail to: @user.email, subject: "¿Quieres aprender a crear tus propias aplicaciones Web?"
  end

  def weekly_email(user, *args)
    @user = user
    @challenges = args[0]
    @resources  = args[1]
    mail to: @user.email, subject: "mantén el ritmo!"
  end
end
