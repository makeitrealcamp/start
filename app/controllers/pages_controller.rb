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
    suffix = ['MX', 'CO', 'PE'].include?(params['country']) ? params['country'].downcase : "other"
    data = {
      pid: cookies[:dp_pid],
      program: "Full Stack Online",
      event: "filled-full-stack-form-#{suffix}",
      first_name: params['first-name'],
      last_name: params['last-name'],
      email: params['email'],
      country: params['country'],
      mobile: params['mobile'],
      source: params['source'],
      gender: params['gender'],
      birthday: params['birthday'],
      ip: request.remote_ip
    }
    CreateLeadJob.perform_later(data)
    redirect_to "/thanks-full-stack-online"
  end

  def create_data_science_online_lead
    suffix = ['MX', 'CO', 'PE'].include?(params['country']) ? params['country'].downcase : "other"
    data = {
      pid: cookies[:dp_pid],
      program: "Data Science Online",
      event: "filled-data-science-form-#{suffix}",
      first_name: params['first-name'],
      last_name: params['last-name'],
      email: params['email'],
      country: params['country'],
      mobile: params['mobile'],
      source: params['source'],
      gender: params['gender'],
      birthday: params['birthday'],
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
    top_applicant_params_updated = top_applicant_params.dup
    
    top_invitation = TopInvitation.find(params[:top_invitation_id])
    raise ActiveRecord::RecordNotFound unless top_invitation

    program_format = top_applicant_params[:format] == "format-full" ? "full" : "partial"
    payment_method = top_applicant_params[:payment_method] == "" ? top_applicant_params[:payment_method_2] : top_applicant_params[:payment_method]

    top_applicant_params_updated.delete(:payment_method_2)
    top_applicant_params_updated[:format] = program_format
    top_applicant_params_updated[:payment_method] = payment_method

    cohort = TopCohort.order(created_at: :desc).take
    TopApplicant.create!(top_applicant_params_updated.merge(email: top_invitation.email, version: 2, cohort: cohort))

    data = {
      name: "filled-top-application",
      person: {
        pid: cookies[:dp_pid],
        email: top_invitation.email,
        first_name: top_applicant_params[:first_name],
        last_name: top_applicant_params[:last_name],
        birthday: top_applicant_params[:birthday],
        country_code: top_applicant_params[:country],
        mobile: top_applicant_params[:mobile],
        gender: top_applicant_params[:gender],
        format: program_format,
        stipend: top_applicant_params[:stipend],
        payment_method: payment_method
      },
      metadata: {
        linkedin: top_applicant_params[:url],
        ip: request.remote_ip,
        goal: top_applicant_params[:goal],
        experience: top_applicant_params[:experience],
        more_info: top_applicant_params[:additional]
      }
    }
    ConvertLoopJob.perform_later(data)
    AdminMailer.new_lead("Top", data[:person][:first_name], data[:person][:last_name], data[:person][:email], data[:person][:country_code],
        data[:person][:mobile], "").deliver_later

    top_invitation.destroy
    redirect_to "/thanks-top"
  end

  def create_innovate_applicant
    InnovateApplicant.create!(innovate_applicant_params)

    format = innovate_applicant_params[:format]
    p format
    suffix = format == "format-full" ? "full" : "partial"

    data = {
      name: "filled-innovate-application-#{suffix}",
      person: {
        pid: cookies[:dp_pid],
        email: innovate_applicant_params[:email],
        first_name: innovate_applicant_params[:first_name],
        last_name: innovate_applicant_params[:last_name],
        birthday: innovate_applicant_params[:birthday],
        country_code: innovate_applicant_params[:country],
        mobile: innovate_applicant_params[:mobile],
        gender: innovate_applicant_params[:gender]
      },
      metadata: {
        linkedin: innovate_applicant_params[:url],
        ip: request.remote_ip,
        goal: innovate_applicant_params[:goal],
        experience: innovate_applicant_params[:experience],
        typical_day: innovate_applicant_params[:typical_day],
        vision: innovate_applicant_params[:vision],
        more_info: innovate_applicant_params[:additional]
      }
    }
    ConvertLoopJob.perform_later(data)
    AdminMailer.new_lead("Innovate", data[:person][:first_name], data[:person][:last_name], data[:person][:email], data[:person][:country_code],
        data[:person][:mobile], "").deliver_later

    redirect_to "/thanks-innovate"
  end

  def create_mitic_applicant
    MiticApplicant.create!(mitic_applicant_params)

    data = {
      name: "filled-mitic-application",
      person: {
        pid: cookies[:dp_pid],
        email: top_applicant_params[:email],
        first_name: top_applicant_params[:first_name],
        last_name: top_applicant_params[:last_name],
        birthday: top_applicant_params[:birthday],
        country_code: top_applicant_params[:country],
        mobile: top_applicant_params[:mobile]
      },
      metadata: {
        linkedin: top_applicant_params[:url],
        ip: request.remote_ip,
        goal: top_applicant_params[:goal],
        experience: top_applicant_params[:experience],
        more_info: top_applicant_params[:additional]
      }
    }
    ConvertLoopJob.perform_later(data)
    AdminMailer.new_lead("Mitic", data[:person][:first_name], data[:person][:last_name], data[:person][:email], data[:person][:country_code],
        data[:person][:mobile], "").deliver_later

    redirect_to "/thanks-mitic"
  end

  def full_stack_online_seat
    @course = Billing::Charge::COURSES[:fullstack]
    @currency = params[:currency] || "COP"
  end

  def ruby_on_rails_seat
    @course = Billing::Charge::COURSES[:backend_rails]
    @currency = params[:currency] || "COP"
  end

  def data_science_online_seat
    @course = Billing::Charge::COURSES[:datascience]
    @currency = params[:currency] || "COP"
  end

  def innovate_full_time_seat
    @course = Billing::Charge::COURSES[:innovate_full_time]
    @currency = params[:currency] || "PEN"
  end

  def innovate_part_time_seat
    @course = Billing::Charge::COURSES[:innovate_part_time]
    @currency = params[:currency] || "PEN"
  end

  def create_ruby_on_rails_lead
    suffix = ['MX', 'CO', 'PE'].include?(params['country']) ? params['country'].downcase : "other"
    data = {
      pid: cookies[:dp_pid],
      program: "Ruby on Rails",
      event: "filled-ruby-on-rails-form-#{suffix}",
      first_name: params['first-name'],
      last_name: params['last-name'],
      email: params['email'],
      country: params['country'],
      mobile: params['mobile'],
      gender: params['gender'],
      birthday: params['birthday'],
      source: params['source'],
      ip: request.remote_ip
    }
    CreateLeadJob.perform_later(data)
    redirect_to "/thanks-ruby-on-rails"
  end

  def create_agile_tester_lead
    suffix = ['MX', 'CO', 'PE'].include?(params['country']) ? params['country'].downcase : "other"
    data = {
      pid: cookies[:dp_pid],
      program: "Agile Tester",
      event: "filled-application-tester-form-#{suffix}",
      first_name: params['first-name'],
      last_name: params['last-name'],
      email: params['email'],
      country: params['country'],
      mobile: params['mobile'],
      gender: params['gender'],
      birthday: params['birthday'],
      source: params['source'],
      ip: request.remote_ip
    }
    CreateLeadJob.perform_later(data)
    redirect_to "/thanks-agile-tester"
  end

  def create_intro_to_js_lead
    data = {
      pid: cookies[:dp_pid],
      program: "Intro to JavaScript Innpulsa",
      event: "filled-intro-to-js-2021-nov-form",
      first_name: params['first-name'],
      last_name: params['last-name'],
      email: params['email'],
      country: params['country'],
      mobile: params['mobile'],
      gender: params['gender'],
      birthday: params['birthday'],
      ip: request.remote_ip
    }
    CreateLeadJob.perform_later(data)
    redirect_to "/thanks-intro-to-js"
  end

  def create_intro_to_python_lead
    data = {
      pid: cookies[:dp_pid],
      program: "Intro to Python",
      event: "filled-intro-to-python-form",
      first_name: params['first-name'],
      last_name: params['last-name'],
      email: params['email'],
      country: params['country'],
      mobile: params['mobile'],
      gender: params['gender'],
      birthday: params['birthday'],
      ip: request.remote_ip
    }
    CreateLeadJob.perform_later(data)
    redirect_to "/thanks-intro-to-python"
  end

  def create_intro_to_html_lead
    data = {
      pid: cookies[:dp_pid],
      program: "Intro to HTML innpulsa",
      event: "filled-intro-to-html-2022-jun-form",
      first_name: params['first-name'],
      last_name: params['last-name'],
      email: params['email'],
      country: params['country'],
      mobile: params['mobile'],
      gender: params['gender'],
      birthday: params['birthday'], 
      ip: request.remote_ip
    }
    CreateLeadJob.perform_later(data)
    redirect_to "/thanks-intro-to-html-and-css"
  end

  def create_fs_becas_mujeres_lead
    data = {
      name: "filled-fs-becas-mujeres-form",
      person: {
        pid: cookies[:dp_pid],
        first_name: params['first-name'],
        last_name: params['last-name'],
        email: params['email'],
        country_code: params['country'],
        mobile: params['mobile'],
        birthday: params['birthday'],
        source: params['source']
      },
      metadata: {
        application_reason: params['application_reason'],
        more_info_url: params['url'],
        ip: request.remote_ip
      }
    }
    ConvertLoopJob.perform_later(data)
    AdminMailer.new_scholarship(data).deliver_later
    redirect_to "/thanks-fs-becas-mujeres"
  end

  def thanks_preparation_top
    applicant = TopApplicant.where("info -> 'uid' = ?", params[:uid]).take

    if applicant
      ConvertLoop.event_logs.send(name: "rsvp-preparation-top", person: { email: applicant.email })
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  private
    def save_referer
      session['referer'] = request.env["HTTP_REFERER"] || 'none' unless session['referer']
    end

    def top_applicant_params
      params.require(:applicant).permit(:accepted_terms, :email, :first_name, :last_name, :country, :mobile, :birthday, :gender, :url, :goal, :experience, :additional, :payment_method, :payment_method_2, :format, :stipend)
    end

    def innovate_applicant_params
      params.require(:applicant).permit(:accepted_terms, :email, :first_name, :last_name, :country, :mobile, :birthday, :gender, :linkedin, :goal, :experience, :additional, :format)
    end

    def mitic_applicant_params
      params.require(:applicant).permit(:accepted_terms, :email, :first_name, :last_name, :country, :mobile, :birthday, :gender, :url, :goal, :experience, :additional)
    end
end
