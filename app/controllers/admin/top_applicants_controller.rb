class Admin::TopApplicantsController < ApplicationController
  before_action :admin_access

  def index
    @cohort = params[:cohort] ? TopCohort.find(params[:cohort]) : TopCohort.order(created_at: :desc).take
    @applicants = @cohort.applicants.order('created_at DESC')
    
    if params[:status].present?
      @applicants = @applicants.where(status: TopApplicant.statuses[params[:status]])
    end

    if params[:q].present?
      @applicants = TopApplicant.order('created_at DESC')
      @applicants = @applicants.where("first_name ILIKE :q OR last_name ILIKE :q OR email ILIKE :q", q: "%#{params[:q]}%")
    end

    @applicants = @applicants.order('created_at DESC')
      .paginate(page: params[:page], per_page: 100)

    @applicants_count = @applicants.count
  end

  def show
    @applicant = TopApplicant.find(params[:id])
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
      params.require(:applicant).permit(:cohort_id, info: [ :prev_salary, :new_salary, :company, :start_date, :contract_type, :socioeconomic_level])
    end
end
