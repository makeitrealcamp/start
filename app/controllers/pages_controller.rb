class PagesController < ApplicationController
  before_action :save_referer, except: [:handbook]

  def home
  end

  def handbook
    client = Octokit::Client.new(
      client_id:     ENV['GITHUB_KEY'],
      client_secret: ENV['GITHUB_SECRET']
    )
    @content = client.contents(
        "makeitrealcamp/handbook",
        path: "README.md", accept: "application/vnd.github.VERSION.raw"
      ).encode("ASCII-8BIT").force_encoding("utf-8")

    render layout: "application"
  end

  def front_end_bootcamp
    @typeform_url = "https://makeitreal.typeform.com/to/Cr9SSv?referer=#{session['referer']}"
  end

  def create_front_end_online_lead
    data = {
      program: "Front End Online",
      event: "filled-front-end-online-form",
      first_name: params['first-name'],
      last_name: params['last-name'],
      email: params['email'],
      country: params['country'],
      mobile: params['mobile'],
      ip: request.remote_ip
    }
    CreateLeadJob.perform_later(data)
    redirect_to "/thanks-front-end-online"
  end

  def create_full_stack_online_lead
    data = {
      program: "Full Stack Online",
      event: "filled-full-stack-online-form",
      first_name: params['first-name'],
      last_name: params['last-name'],
      email: params['email'],
      country: params['country'],
      mobile: params['mobile'],
      ip: request.remote_ip
    }
    CreateLeadJob.perform_later(data)
    redirect_to "/thanks-full-stack-online"
  end

  def send_web_developer_guide
    subscriber = SubscriberForm.new(params)

    intercom = Intercom::Client.new(app_id: ENV['INTERCOM_APP_ID'], api_key: ENV['INTERCOM_KEY'])
    user = intercom.users.create(email: subscriber.email, name: "#{subscriber.first_name} #{subscriber.last_name}", custom_attributes: { "User Goal" => subscriber.goal })
    intercom.events.create(
      event_name: "requested-developer-guide", created_at: Time.now.to_i,
      email: subscriber.email,
      metadata: {
        ip: request.remote_ip
      }
    )
    PagesMailer.web_developer_guide(subscriber).deliver_now

    respond_to do |format|
      format.html do
        @email_sent = true
        render :web_developer_guide
      end
      format.js
    end
  end

  def download_web_developer_guide
    if params[:email].blank?
      redirect_to root_path
      return
    end

    intercom = Intercom::Client.new(app_id: ENV['INTERCOM_APP_ID'], api_key: ENV['INTERCOM_KEY'])
    intercom.events.create(
      event_name: "downloaded-developer-guide", created_at: Time.now.to_i,
      email: params[:email],
      metadata: {
        ip: request.remote_ip
      }
    )

    redirect_to "https://s3.amazonaws.com/makeitreal/e-books/convertirte-en-desarrollador-web.pdf"
  end

  private
    def save_referer
      session['referer'] = request.env["HTTP_REFERER"] || 'none' unless session['referer']
    end
end
