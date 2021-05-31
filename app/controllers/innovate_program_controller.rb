class InnovateProgramController < ApplicationController
  def challenge
    @applicant = InnovateApplicant.where("info -> 'uid' = ?", params[:uid]).take
    render :applicant_not_found and return if @applicant.nil?

    if @applicant.valid_code
      redirect_to innovate_program_test_path(uid: params[:uid])
    else
      @secret_code = Base64.strict_encode64(@applicant.uid)
      notify_converloop({ name: "opened-innovate-challenge", email: @applicant.email })
    end
  end

  def submit_challenge
    @applicant = InnovateApplicant.where("info -> 'uid' = ?", params[:uid]).take
    render :applicant_not_found and return if @applicant.nil?

    if has_completed_challenge(@applicant)
      redirect_to innovate_program_challenge_path
    else
      uid = decode_uid(params[:code])
      if uid == @applicant.uid # check if challenge is valid
        @applicant.update!(valid_code: true)
        notify_converloop({ name: "solved-innovate-challenge", email: @applicant.email })
        redirect_to innovate_program_challenge_path(uid: params[:uid])
      else
        @secret_code = Base64.strict_encode64(@applicant.uid)
        @invalid_code = true
        notify_converloop({ name: "attempted-innovate-challenge", email: @applicant.email })
        render :challenge
      end
    end
  end

  def test
    applicant = InnovateApplicant.where("info -> 'uid' = ?", params[:uid]).take
    render :applicant_not_found and return if applicant.nil?

    if !has_completed_challenge(applicant)
      redirect_to innovate_program_challenge_path(uid: params[:uid])
    elsif has_submitted_test(applicant)
      render :already_submitted
    else
      @test = InnovateApplicantTest.new(applicant: applicant)
      notify_converloop({ name: "opened-innovate-test", email: applicant.email })
    end
  end

  def submit_test
    applicant = InnovateApplicant.find_by(id: params[:applicant_id])
    render :applicant_not_found and return if applicant.nil?

    @test = InnovateApplicantTest.new(test_params.merge(applicant: applicant))
    if @test.save
      notify_converloop({ name: "submitted-innovate-test", email: applicant.email })
      AdminMailer.innovate_test_submitted(applicant).deliver_later
      create_test_received_activity(applicant)

      redirect_to innovate_program_submitted_path
    else
      render :test
    end
  end

  protected
    def test_params
      params.require(:innovate_applicant_test).permit(:lang, :a1, :a2, :a3)
    end

    def has_completed_challenge(applicant)
      applicant.valid_code
    end

    def has_submitted_test(applicant)
      InnovateApplicantTest.exists?(applicant: applicant)
    end

    def notify_converloop(data)
      ConvertLoopJob.perform_later(data.merge(pid: cookies[:dp_pid]))
    end

    def create_test_received_activity(applicant)
      status = applicant.status
      applicant.test_received!
      applicant.change_status_activities.create!(from_status: status, to_status: "test_received", comment: "<a href=\"/admin/innovate_applicant_tests/#{@test.id}\" data-remote=\"true\">Ver la prueba técnica</a>")
    end

    def decode_uid(code)
      begin
        Base64.strict_decode64(code)
      rescue ArgumentError => e
        "invalid uid" # return invalid uid
      end
    end
end
