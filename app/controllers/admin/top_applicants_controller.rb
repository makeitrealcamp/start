class Admin::TopApplicantsController < ApplicationController
  before_action :admin_access

  def index
    @cohort = params[:cohort] ? TopCohort.find(params[:cohort]) : TopCohort.order(created_at: :desc).take
    @applicants = @cohort.applicants.order('created_at DESC')

    if params[:status].present?
      @applicants = @applicants.where(status: TopApplicant.statuses[params[:status]])
    end

    if params[:q].present?
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
    @applicant.update(applicant_params)
  end

  private
    def applicant_params
      params.require(:applicant).permit(:cohort_id)
    end
end
