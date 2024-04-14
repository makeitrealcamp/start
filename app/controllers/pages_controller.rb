class PagesController < ApplicationController
  before_action :save_referer, except: [:handbook]
  protect_from_forgery with: :null_session
  
  def home
  end

  def top_full_and_part_time
    @ab_test = ab_test(:hero_top, 'control', 'variant')
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

  def create_lead
    suffix = ['CO'].include?(params['country']) ? params['country'].downcase : "other"
    data = {
      pid: cookies[:dp_pid],
      program: params['program-name'],
      event: "#{params['convertloop-event']}-#{suffix}",
      first_name: params['first-name'],
      last_name: params['last-name'],
      email: params['email'],
      country: params['country'],
      mobile: params['mobile'],
      ip: request.remote_ip
    }
    data[:document_type] = params['document-type'] if params['document-type']
    data[:document_number] = params['document-number'] if params['document-number']
    data[:accepted_terms] = params['accepted-terms'] if params['accepted-terms']
    data[:birthday] = params['birthday'] if params['birthday']
    data[:gender] = params['gender'] if params['gender']

    CreateLeadJob.perform_later(data)
    
    render json: { message: 'Success' }, status: :ok
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
        render_api_response(subscriber, :web_developer_guide, nil)
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

    # program_format = top_applicant_params[:format] == "format-full" ? "full" : "partial"
    payment_method = top_applicant_params[:payment_method] == "" ? top_applicant_params[:payment_method_2] : top_applicant_params[:payment_method]

    top_applicant_params_updated.delete(:payment_method_2)
    # top_applicant_params_updated[:format] = program_format
    top_applicant_params_updated[:payment_method] = payment_method
    top_applicant_params_updated[:accepted_terms] = true

    cohort = TopCohort.order(created_at: :desc).take
    @top_applicant = TopApplicant.create!(top_applicant_params_updated.merge(email: top_invitation.email, version: 2, cohort: cohort))

    ab_finished(:hero_top)

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
        # format: program_format,
        stipend: top_applicant_params[:stipend],
        payment_method: payment_method,
        top_uid: @top_applicant.uid
      },
      metadata: {
        linkedin: top_applicant_params[:url],
        ip: request.remote_ip,
        goal: top_applicant_params[:goal],
        experience: top_applicant_params[:experience],
        more_info: top_applicant_params[:additional],
        studies: top_applicant_params[:studies],
        working: top_applicant_params[:working]
      }
    }
    if cohort
      data[:metadata][:cohort_id] = "#{cohort.id}"
      data[:metadata][:cohort_name] = cohort.name
    end
    ConvertLoopJob.perform_later(data)
    AdminMailer.new_lead("Top", data[:person][:first_name], data[:person][:last_name], data[:person][:email], data[:person][:country_code],
        data[:person][:mobile], "").deliver_later

    top_invitation.destroy
    render_api_response(@top_applicant, nil, "/thanks-top")
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

  def create_proinnovate_2024_applicant
    ProinnovateApplicant.create!(innovate_applicant_params) 
        
    data = {
      name: innovate_applicant_params[:convertloop_event],
      person: {
        pid: cookies[:dp_pid],
        email: innovate_applicant_params[:email],
        first_name: innovate_applicant_params[:first_name],
        second_name: innovate_applicant_params[:second_name],
        last_name: innovate_applicant_params[:last_name],
        second_last_name: innovate_applicant_params[:second_last_name],
        birthday: innovate_applicant_params[:birthday],
        country_code: innovate_applicant_params[:country],
        mobile: innovate_applicant_params[:mobile],
        gender: innovate_applicant_params[:gender],
        document_type: innovate_applicant_params[:document_type],
        document_number: innovate_applicant_params[:document_number],
        project_code: innovate_applicant_params[:project_code],
        program_name: innovate_applicant_params[:program_name],
      },
      metadata: {
        linkedin: innovate_applicant_params[:url],
        ip: request.remote_ip,
        goal: innovate_applicant_params[:goal],
        experience: innovate_applicant_params[:experience],
        studies: innovate_applicant_params[:studies],
        working: innovate_applicant_params[:working]
      }
    }

    ConvertLoopJob.perform_later(data)
    AdminMailer.new_lead("Proinnovate Becas 2024", data[:person][:first_name], data[:person][:last_name], data[:person][:email], data[:person][:country_code],
        data[:person][:mobile], "").deliver_later
    render json: { message: 'Success' }, status: :ok
  end

  def create_proinnovate_2024_lead
    data = {
      name: params[:convertloop_event],
      person: {
        pid: cookies[:dp_pid],
        email: params[:email],
        first_name: params[:first_name],
        second_name: params[:second_name],
        last_name: params[:last_name],
        second_last_name: params[:second_last_name],
        birthday: params[:birthday],
        country_code: params[:country],
        mobile: params[:mobile],
        gender: params[:gender],
        document_type: params[:document_type],
        document_number: params[:document_number],
        project_code: params[:project_code],
        program_name: params[:program_name],
      },
      metadata: {
        linkedin: params[:url],
        ip: request.remote_ip,
        goal: params[:goal],
        experience: params[:experience],
        studies: params[:studies],
        working: params[:working]
      }
    }
    ConvertLoopJob.perform_later(data)
    render json: { message: 'Success' }, status: :ok
  end

  def create_mitic_applicant
    program_name = mitic_applicant_params[:program_name]

    case program_name
    when "AI"
      MiticAiApplicant.create!(mitic_applicant_params)
    when "Serverless"
      MiticServerlessApplicant.create!(mitic_applicant_params)
    when "Data-Analysis"
      MiticDataAnalysisApplicant.create!(mitic_applicant_params)
    when "Web3"
      MiticWeb3Applicant.create!(mitic_applicant_params)
    else
      MiticApplicant.create!(mitic_applicant_params)
    end

    data = {
      name: "applied-to-mitic-#{program_name}",
      person: {
        pid: cookies[:dp_pid],
        email: mitic_applicant_params[:email],
        first_name: mitic_applicant_params[:first_name],
        last_name: mitic_applicant_params[:last_name],
        birthday: mitic_applicant_params[:birthday],
        country_code: mitic_applicant_params[:country],
        mobile: mitic_applicant_params[:mobile],
        resubscribe: true
      },
      metadata: {
        linkedin: mitic_applicant_params[:url],
        ip: request.remote_ip,
        goal: mitic_applicant_params[:goal],
        experience: mitic_applicant_params[:experience],
        more_info: mitic_applicant_params[:additional]
      }
    }
    
    ConvertLoopJob.perform_later(data)
    AdminMailer.new_lead("Mitic", data[:person][:first_name], data[:person][:last_name], data[:person][:email], data[:person][:country_code],
        data[:person][:mobile], data[:person][:program_name], "").deliver_later

    render json: { message: 'Success' }, status: :ok
  end

  def create_women_applicant
    @women_applicant = WomenApplicant.create!(mitic_applicant_params)

    data = {
      name: "Filled-Nesst-Women-Bootcamp-Application",
      person: {
        pid: cookies[:dp_pid],
        email: women_applicant_params[:email],
        first_name: women_applicant_params[:first_name],
        last_name: women_applicant_params[:last_name],
        birthday: women_applicant_params[:birthday],
        country_code: women_applicant_params[:country],
        mobile: women_applicant_params[:mobile]
      },
      metadata: {
        linkedin: women_applicant_params[:url],
        ip: request.remote_ip,
        goal: women_applicant_params[:goal],
        experience: women_applicant_params[:experience],
        more_info: women_applicant_params[:additional]
      }
    }
    ConvertLoopJob.perform_later(data)
    AdminMailer.new_lead("Nesst Women Bootcamp", data[:person][:first_name], data[:person][:last_name], data[:person][:email], data[:person][:country_code],
        data[:person][:mobile], "").deliver_later

    render_api_response(@women_applicant, nil, "/thanks-top")
  end

  def full_stack_online_seat
    @course = Billing::Charge::COURSES[:fullstack]
    @currency = params[:currency] || "COP"
  end

  def bootcamp_mujeres_seat
    @course = Billing::Charge::COURSES[:bootcamp_mujeres]
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

  def qa_manual_testing_seat
    @course = Billing::Charge::COURSES[:qa_manual_testing]
    @currency = params[:currency] || "COP"
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
      event: "filled-intro-to-js-2022-sep-form",
      first_name: params['first-name'],
      last_name: params['last-name'],
      docType: params['docType'],
      docNumber: params['docNumber'],
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
      params.require(:applicant).permit(:accepted_terms, :email, :first_name, :last_name, :country, :mobile, :birthday, :gender, :url, :goal, :experience, :additional, :payment_method, :payment_method_2, :format, :stipend, :working, :studies)
    end

    def innovate_applicant_params
      params.require(:applicant).permit(:accepted_terms, :email, :first_name, :second_name, :last_name, :second_last_name, :country, :mobile, :birthday, :gender, :url, :goal, :experience, :additional, :studies, :working, :format, :document_type, :document_number, :project_code, :program_name, :convertloop_event)
    end

    def mitic_applicant_params
      params.require(:applicant).permit(:accepted_terms, :program_name, :email, :first_name, :last_name, :country_code, :mobile, :birthday, :gender, :url, :goal, :experience, :additional, :studies, :working, :resubscribe)
    end

    def women_applicant_params
      params.require(:applicant).permit(:accepted_terms, :email, :first_name, :last_name, :country, :mobile, :birthday, :gender, :url, :goal, :experience, :additional, :payment_method, :payment_method_2, :format, :stipend, :working, :studies)
    end
end
