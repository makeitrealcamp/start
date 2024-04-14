class Admin::MiticServerlessApplicantsController < ApplicationController
  before_action :admin_access

  def index
    order_by = params[:order_by].present? ? params[:order_by] : 'created_at'
    @applicants = MiticServerlessApplicant.order("#{order_by} DESC")

    if params[:status].present?
      @applicants = @applicants.where(status: MiticServerlessApplicant.statuses[params[:status]])
    end

    if params[:q].present?
      @applicants = @applicants.where("first_name ILIKE :q OR last_name ILIKE :q OR email ILIKE :q", q: "%#{params[:q]}%")
    end

    if params[:status].present? and params[:substate].present?
      @applicants = @applicants.find_applicant_by_substate(MiticServerlessApplicant, params[:status], params[:substate])
    end

    @applicants = @applicants.order('created_at DESC')
      .paginate(page: params[:page], per_page: 100)

    @applicants_count = @applicants.count
  end

  def show
    @applicant = MiticServerlessApplicant.find(params[:id])
  end

  def edit
    @applicant = MiticServerlessApplicant.find(params[:id])
  end

  def update
    @applicant = MiticServerlessApplicant.find(params[:id])
    @applicant.update_column(:info, @applicant.info.merge(aplication_params[:info]) )
    # @applicant.update({ cohort_id: aplication_params[:cohort_id] })
  end

  def aplication_params
    params.require(:applicant).permit( info: [ :prev_salary, :new_salary, :company, :start_date, :contract_type, :socioeconomic_level, :referred_by])
    # params.require(:top_applicant).permit(:comment)
  end
end
