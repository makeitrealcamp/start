class Admin::TopApplicantsController < ApplicationController
  before_action :admin_access

  def index
    @cohort = params[:cohort] ? TopCohort.find(params[:cohort]) : TopCohort.order(created_at: :desc).take
    @applicants = @cohort.applicants
    
    if params[:status].present?
      @applicants = @applicants.where(status: TopApplicant.statuses[params[:status]])
    end

    if params[:program].present?
      @applicants = @applicants.where("info -> 'format' = ?", params[:program])
    end

    if params[:orderby].present?
      @applicants = @applicants.order("#{params[:orderby]} DESC")
    else
      @applicants = @applicants.order('created_at DESC')
    end

    if params[:q].present?
      @applicants = TopApplicant.where("first_name ILIKE :q OR last_name ILIKE :q OR email ILIKE :q", q: "%#{params[:q]}%")
    end

    if params[:status].present? and params[:substate].present?
      @applicants = @applicants.find_applicant_by_substate(TopApplicant, params[:status], params[:substate])
    end

    @applicants = @applicants.paginate(page: params[:page], per_page: 100)
    @applicants_count = @applicants.count
  end

  def show
    @applicant = TopApplicant.find(params[:id])
    @prev_applications = @applicant.previous_applications
  end

  def edit
    @applicant = TopApplicant.find(params[:id])
  end

  def update
    @applicant = TopApplicant.find(params[:id])
    @applicant.update_column(:info, @applicant.info.merge(applicant_params[:info]) )
    @applicant.update({ cohort_id: applicant_params[:cohort_id] })
  end

  private
    def applicant_params
      params.require(:applicant).permit(:cohort_id, info: [ :format, :prev_salary, :new_salary, :company, :start_date, :contract_type, :socioeconomic_level, :referred_by, :payment_method, :applicant_level, :tech_level, :profile_level, :english_level])
    end
end
