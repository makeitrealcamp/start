class PagesController < ApplicationController
  before_action :save_referer, except: [:handbook]

  def home
  end

  def react_redux
    @valid_coupon = false
    if params[:coupon].present?
      @coupon = Billing::Coupon.where(name: params[:coupon]).take
      if @coupon && @coupon.expires_at > DateTime.current
        @valid_coupon = true
      end
    end
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

  def create_full_stack_bogota_lead
    data = {
      pid: cookies[:dp_pid],
      program: "Full Stack Bogota",
      event: "filled-full-stack-bogota-form",
      first_name: params['first-name'],
      last_name: params['last-name'],
      email: params['email'],
      country: "CO",
      mobile: params['mobile'],
      ip: request.remote_ip
    }
    CreateLeadJob.perform_later(data)
    redirect_to "/thanks-full-stack-bogota"
  end

  def create_full_stack_barranquilla_lead
    data = {
      pid: cookies[:dp_pid],
      program: "Full Stack Barranquilla",
      event: "filled-full-stack-barranquilla-form",
      first_name: params['first-name'],
      last_name: params['last-name'],
      email: params['email'],
      country: "CO",
      mobile: params['mobile'],
      ip: request.remote_ip
    }
    CreateLeadJob.perform_later(data)
    redirect_to "/thanks-full-stack-barranquilla"
  end

  def create_full_stack_bucaramanga_lead
    data = {
      pid: cookies[:dp_pid],
      program: "Full Stack Bucaramanga",
      event: "filled-full-stack-bucaramanga-form",
      first_name: params['first-name'],
      last_name: params['last-name'],
      email: params['email'],
      country: "CO",
      mobile: params['mobile'],
      ip: request.remote_ip
    }
    CreateLeadJob.perform_later(data)
    redirect_to "/thanks-full-stack-bucaramanga"
  end

  def create_full_stack_cali_lead
    data = {
      pid: cookies[:dp_pid],
      program: "Full Stack Cali",
      event: "filled-full-stack-cali-form",
      first_name: params['first-name'],
      last_name: params['last-name'],
      email: params['email'],
      country: "CO",
      mobile: params['mobile'],
      ip: request.remote_ip
    }
    CreateLeadJob.perform_later(data)
    redirect_to "/thanks-full-stack-cali"
  end

  def create_front_end_bogota_lead
    data = {
      pid: cookies[:dp_pid],
      program: "Front End Bogota",
      event: "filled-front-end-bogota-form",
      first_name: params['first-name'],
      last_name: params['last-name'],
      email: params['email'],
      country: "CO",
      mobile: params['mobile'],
      ip: request.remote_ip
    }
    CreateLeadJob.perform_later(data)
    redirect_to "/thanks-front-end-bogota"
  end

  def create_front_end_medellin_lead
    data = {
      pid: cookies[:dp_pid],
      program: "Front End Medellin",
      event: "filled-front-end-medellin-form",
      first_name: params['first-name'],
      last_name: params['last-name'],
      email: params['email'],
      country: "CO",
      mobile: params['mobile'],
      ip: request.remote_ip
    }
    CreateLeadJob.perform_later(data)
    redirect_to "/thanks-front-end-medellin"
  end

  def create_scholarship_application
    data = {
      name: "filled-scholarship-form",
      person: {
        pid: cookies[:dp_pid],
        email: params['email'],
        first_name: params['first-name'],
        last_name: params['last-name'],
        age: params['age'],
        country: params['country'],
        mobile: params['mobile'],
        skype: params['skype'],
        twitter: params['twitter'],
        portafolio_url: params['portafolio_url']
      },
      metadata: {
        scholarship: "Women March 2017",
        ip: request.remote_ip,
        application_reason: params['application_reason'],
        experience: params['experience'],
        more_info: params['more_info']
      }
    }

    ConvertLoopJob.perform_later(data)
    AdminMailer.new_scholarship(data).deliver_later
    redirect_to "/thanks-scholarships"
  end

  def send_web_developer_guide
    subscriber = SubscriberForm.new(params)

    person = { pid: cookies[:dp_pid], email: subscriber.email, first_name: subscriber.first_name,
        last_name: subscriber.last_name, user_goal: subscriber.goal }
    begin
      ConvertLoop.event_logs.send(name: "requested-developer-guide", person: person)
    rescue => e
      Rails.logger.error "Couldn't send event requested-developer-guide to ConvertLoop: #{e.message}"
    end
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
    begin
      ConvertLoop.event_logs.send(name: "downloaded-developer-guide", person: person, metadata: metadata)
    rescue => e
      Rails.logger.error "Couldn't send event downloaded-developer-guide to ConvertLoop: #{e.message}"
      Rails.logger.error "Backtrace: \n\t#{e.backtrace.join("\n\t")}"
    end

    redirect_to "https://s3.amazonaws.com/makeitreal/e-books/convertirte-en-desarrollador-web.pdf"
  end

  private
    def save_referer
      session['referer'] = request.env["HTTP_REFERER"] || 'none' unless session['referer']
    end
end
