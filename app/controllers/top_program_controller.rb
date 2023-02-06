class TopProgramController < ApplicationController
  def challenge
    @applicant = TopApplicant.where("info -> 'uid' = ?", params[:uid]).take
    render :applicant_not_found and return if @applicant.nil?

    if @applicant.valid_code
      redirect_to top_program_test_path(uid: params[:uid])
    else
      @secret_code = Base64.strict_encode64(@applicant.uid)
      notify_converloop({ name: "opened-top-challenge", email: @applicant.email })
    end
  end

  def submit_challenge
    @applicant = TopApplicant.where("info -> 'uid' = ?", params[:uid]).take
    render :applicant_not_found and return if @applicant.nil?

    if has_completed_challenge(@applicant)
      redirect_to top_program_challenge_path
    else
      uid = decode_uid(params[:code])
      if uid == params[:uid] # check if challenge is valid
        @applicant.update!(valid_code: true)
        notify_converloop({ name: "solved-top-challenge", email: @applicant.email })
        redirect_to top_program_challenge_path(uid: params[:uid])
      else
        @secret_code = Base64.strict_encode64(@applicant.uid)
        @invalid_code = true
        notify_converloop({ name: "attempted-top-challenge", email: @applicant.email })
        render :challenge
      end
    end
  end

  def test
    applicant = TopApplicant.where("info -> 'uid' = ?", params[:uid]).take
    render :applicant_not_found and return if applicant.nil?

    if !has_completed_challenge(applicant)
      redirect_to top_program_challenge_path(uid: params[:uid])
    elsif has_submitted_test(applicant)
      render :already_submitted
    else
      @test = TopApplicantTest.new(applicant: applicant)
      notify_converloop({ name: "opened-top-test", email: applicant.email })
    end
  end

  def submit_test
    applicant = TopApplicant.find_by(id: params[:applicant_id])
    render :applicant_not_found and return if applicant.nil?

    @test = TopApplicantTest.new(test_params.merge(applicant: applicant))
    if @test.save
      notify_converloop({ name: "submitted-top-test", email: applicant.email })
      AdminMailer.top_test_submitted(applicant).deliver_later
      create_test_received_activity(applicant)

      redirect_to top_program_submitted_path
    else
      render :test
    end
  end

  def confirm_aspiring_course
    @title = "Curso Aspirantes TOP"
    @applicant = TopApplicant.where("info -> 'uid' = ?", params[:uid]).take
    render :applicant_not_found and return if @applicant.nil?

    if @applicant and !@applicant.aspiring_course_accepted?
      from_status = @applicant.status
     @applicant.update(status: :aspiring_course, aspiring_course_accepted: true)

      data = { user: current_user, from_status: from_status }
      @activity = @applicant.change_status_activities.create(data.merge(to_status: "aspiring_course", comment: "Aceptó el curso de Aspirantes TOP"))
      notify_converloop({ name: "Accepted to  Aspirantes TOP", email: @applicant.email })
    else
      render :already_applied
    end
  end

  protected
    def test_params
      params.require(:top_applicant_test).permit(:a1, :a2, :a3, :a4, :lang)
    end

    def has_completed_challenge(applicant)
      applicant.valid_code
    end

    def has_submitted_test(applicant)
      TopApplicantTest.exists?(applicant: applicant)
    end

    def notify_converloop(data)
      ConvertLoopJob.perform_later(data.merge(pid: cookies[:dp_pid]))
    end

    def create_test_received_activity(applicant)
      status = applicant.status
      applicant.test_received!
      applicant.change_status_activities.create!(from_status: status, to_status: "test_received", comment: "<a href=\"/admin/top_applicant_tests/#{@test.id}\" data-remote=\"true\">Ver la prueba técnica</a>")
    end

    def decode_uid(code)
      begin
        Base64.strict_decode64(code)
      rescue ArgumentError => e
        "invalid uid" # return invalid uid
      end
    end
end
