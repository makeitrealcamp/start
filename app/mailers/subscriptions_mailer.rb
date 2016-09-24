class SubscriptionsMailer < ApplicationMailer
  include Roadie::Rails::Automatic
  
  def activate(user)
     @user = user
     mail to: @user.email, subject: "¡#{genderize("Bienvenido", "Bienvenida", @user)} a Make it Real! Activa tu cuenta"
   end

  def welcome_slack(user)
    @user = user
    mail to: @user.email, subject: "¡Bienvenido a Make it Real!"
  end
end
