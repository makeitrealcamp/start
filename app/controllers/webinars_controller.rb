class WebinarsController < ApplicationController
  layout "pages"

  def index
    @upcoming = Webinars::Webinar.upcoming
    @past = Webinars::Webinar.past
  end

  def show
    @webinar = Webinars::Webinar.where(slug: params[:id]).take
  end

  def register
    @webinar = Webinars::Webinar.where(slug: params[:id]).take
    participant = @webinar.participants.where(email: participant_params[:email]).first_or_create do |p|
      p.first_name = participant_params[:first_name]
      p.last_name = participant_params[:last_name]
    end

    if @webinar.is_past?
      PagesMailer.watch_webinar(@webinar, participant).deliver_now
      notify_convertloop("webinar-watch", @webinar, participant)
    else
      PagesMailer.rsvp_webinar(@webinar, participant).deliver_now
      notify_convertloop("webinar-rsvp", @webinar, participant)
    end
  end

  def watch
    @webinar = Webinars::Webinar.where(slug: params[:id]).take
    @participant = @webinar.participants.where(token: params[:token]).take
  end

  def attend
    webinar = Webinars::Webinar.where(slug: params[:id]).take
    participant = webinar.participants.where(token: params[:token]).take

    if participant
      redirect_to "#{webinar.event_url}"
    end
  end

  def calendar
    @webinar = Webinars::Webinar.where(slug: params[:id]).take
    @participant = @webinar.participants.where(token: params[:token]).take
  end

  def ical
    webinar = Webinars::Webinar.where(slug: params[:id]).take
    participant = webinar.participants.where(token: params[:token]).take

    cal = Icalendar::Calendar.new
    filename = "makeitreal"

    if params[:format] == 'vcs'
      cal.prodid = '-//Microsoft Corporation//Outlook MIMEDIR//EN'
      cal.version = '1.0'
      filename += '.vcs'
    else # ical
      cal.prodid = '-//Acme Widgets, Inc.//NONSGML ExportToCalendar//EN'
      cal.version = '2.0'
      filename += '.ics'
    end

    cal.event do |e|
      e.dtstart     = Icalendar::Values::DateTime.new(webinar.date_in_timezone)
      e.dtend       = Icalendar::Values::DateTime.new(webinar.date_in_timezone + 45.minutes)
      e.summary     = "Webinar Make it Real"
      e.description = webinar.title
      e.url         = attend_webinar_url(webinar.slug)
      e.location    = "YouTube Live"
    end

    send_data cal.to_ical, type: 'text/calendar', disposition: 'attachment', filename: filename
  end

  private
    def participant_params
      params.require(:webinars_participant).permit(:email, :first_name, :last_name)
    end

    def notify_convertloop(event, webinar, participant)
      ConvertLoop.event_logs.send(
        name: event,
        person: {
          email: participant.email,
          first_name: participant.first_name,
          last_name: participant.last_name
        },
        metadata: { webinar: @webinar.title }
      )
    rescue => e
      Rails.logger.error "Couldn't send event to ConvertLoop: #{e.message}"
    end
end
