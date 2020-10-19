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

  def create_data_science_online_lead
    data = {
      pid: cookies[:dp_pid],
      program: "Data Science Online",
      event: "filled-data-science-online-form",
      first_name: params['first-name'],
      last_name: params['last-name'],
      email: params['email'],
      country: params['country'],
      mobile: params['mobile'],
      ip: request.remote_ip
    }
    CreateLeadJob.perform_later(data)
    redirect_to "/thanks-data-science-online"
  end

  def send_web_developer_guide
    subscriber = SubscriberForm.new(params.to_unsafe_hash)

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

  def create_top_applicant
    TopApplicant.create!(top_applicant_params)

    data = {
      name: "filled-top-application",
      pid: cookies[:dp_pid],
      email: top_applicant_params[:email],
      first_name: top_applicant_params[:first_name],
      last_name: top_applicant_params[:last_name],
      birthday: top_applicant_params[:birthday],
      country: top_applicant_params[:country],
      mobile: top_applicant_params[:mobile],
      portafolio_url: top_applicant_params[:url],
      ip: request.remote_ip,
      goal: top_applicant_params[:goal],
      experience: top_applicant_params[:experience],
      typical_day: top_applicant_params[:typical_day],
      vision: top_applicant_params[:vision],
      more_info: top_applicant_params[:additional]
    }
    ConvertLoopJob.perform_later(data)
    AdminMailer.new_lead("Top", data[:first_name], data[:last_name], data[:email], data[:country],
        data[:mobile]).deliver_later

    redirect_to "/thanks-top"
  end

  def full_stack_online_seat
    @course = Billing::Charge::COURSES[:fullstack]
    @currency = params[:currency] || "COP"
  end

  def data_science_online_seat
    @course = Billing::Charge::COURSES[:datascience]
    @currency = params[:currency] || "COP"
  end

  def create_intro_to_js_lead
    data = {
      pid: cookies[:dp_pid],
      program: "Intro to Java Script",
      event: "filled-intro-to-js-form",
      first_name: params['first-name'],
      last_name: params['last-name'],
      email: params['email'],
      country: params['country'],
      mobile: params['mobile'],
      ip: request.remote_ip
    }
    CreateLeadJob.perform_later(data)
    redirect_to "/thanks-intro-to-js"
  end

  def create_fs_becas_mujeres_lead
    data = {
      name: "filled-fs-becas-mujeres-form",
      person: {
        pid: cookies[:dp_pid],
        first_name: params['first-name'],
        last_name: params['last-name'],
        email: params['email'],
        country: params['country']
      },
      metadata: {
        age: params['age'],
        application_reason: params['application_reason'],
        more_info_url: params['url'],
        ip: request.remote_ip
      }
    }
    ConvertLoopJob.perform_later(data)
    AdminMailer.new_scholarship(data).deliver_later
    redirect_to "/thanks-fs-becas-mujeres"
  end

  private
    def save_referer
      session['referer'] = request.env["HTTP_REFERER"] || 'none' unless session['referer']
    end

    def top_applicant_params
      params.require(:applicant).permit(:accepted_terms, :email, :first_name, :last_name, :country, :mobile, :birthday, :gender, :url, :goal, :experience, :typical_day, :vision, :additional, :payment_method)
    end
end
