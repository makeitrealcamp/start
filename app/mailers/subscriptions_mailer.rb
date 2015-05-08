class SubscriptionsMailer < ApplicationMailer

  def welcome_mail(user)
    @user = user
    mail to: @user.email, subject: "Bienvenido a Make it Real NOW"
  end

end
