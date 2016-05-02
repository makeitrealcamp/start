class PagesMailer < ApplicationMailer

  def web_developer_guide(subscriber)
    @subscriber = subscriber
    mail to: @subscriber.email, from: "german.escobar@makeitreal.camp", subject: "[E-book] ¿Cómo convertirte en Desarrollador Web?"
  end
end
