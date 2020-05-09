class PagesMailer < ApplicationMailer
  include Roadie::Rails::Automatic

  def web_developer_guide(subscriber)
    @subscriber = subscriber
    mail to: @subscriber.email, from: "german.escobar@makeitreal.camp", subject: "[E-book] ¿Cómo convertirte en Desarrollador Web?"
  end

  def rsvp_webinar(webinar, participant)
    @webinar = webinar
    @participant = participant

    mail to: @participant.email, from: "info@makeitreal.camp", subject: "Tu asistencia al Webinar #{@webinar.title}!"
  end

  def watch_webinar(webinar, participant)
    @webinar = webinar
    @participant = participant

    mail to: @participant.email, from: "info@makeitreal.camp", subject: "Tu acceso al Webinar #{@webinar.title}!"
  end
end
