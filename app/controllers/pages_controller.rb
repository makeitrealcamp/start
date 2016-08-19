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
      pid: cookies[:dp_pid],
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
      pid: cookies[:dp_pid],
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

  def create_full_stack_medellin_lead
    data = {
      pid: cookies[:dp_pid],
      program: "Full Stack Medellin",
      event: "filled-full-stack-medellin-form",
      first_name: params['first-name'],
      last_name: params['last-name'],
      email: params['email'],
      country: "CO",
      mobile: params['mobile'],
      ip: request.remote_ip
    }
    CreateLeadJob.perform_later(data)
    redirect_to "/thanks-full-stack-medellin"
  end

  def send_web_developer_guide
    subscriber = SubscriberForm.new(params)

    person = { pid: cookies[:dp_pid], email: subscriber.email, first_name: subscriber.first_name,
        last_name: subscriber.last_name, user_goal: subscriber.goal }
    ConvertLoop.event_logs.send(name: "requested-developer-guide", person: person)

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

    person = { email: params[:email] }
    metadata = { ip: request.remote_ip }
    ConvertLoop.event_logs.send(name: "downloaded-developer-guide", person: person, metadata: metadata)

    redirect_to "https://s3.amazonaws.com/makeitreal/e-books/convertirte-en-desarrollador-web.pdf"
  end

  private
    def save_referer
      session['referer'] = request.env["HTTP_REFERER"] || 'none' unless session['referer']
    end
end
