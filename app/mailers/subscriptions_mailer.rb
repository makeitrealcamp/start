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

  def charge_instructions(charge)
    @charge = charge

    mail to: charge.email, subject: "Instrucciones de pago"
  end

  def charge_validation(charge)
    @charge = charge

    mail to: charge.email, subject: "Pago en proceso de validación"
  end

  def charge_rejected(charge)
    @charge = charge

    mail to: charge.email, subject: "Pago rechazado por la entidad financiera"
  end

  def course(charge)
    @charge = charge

    mail to: charge.email, subject: "Pago exitoso! Inicia tu aprendizaje ahora"
  end

  def course_welcome(charge)
    @charge = charge

    mail to: charge.email, subject: "Pago exitoso! Inicia tu aprendizaje ahora"
  end
end
