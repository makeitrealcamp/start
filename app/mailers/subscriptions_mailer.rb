class SubscriptionsMailer < ApplicationMailer

  def welcome_mail(user)
    @user = user
    mail to: @user.email, subject: "¡Bienvenido a Make it Real!"
  end

  def welcome_hangout(user)
    @user = user
    mail to: @user.email, subject: "Hangout de Bienvenida!"
  end
end
