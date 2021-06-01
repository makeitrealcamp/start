class Admin::InnovateApplicantsController < ApplicationController
  before_action :admin_access

  def index
    order_by = params[:order_by].present? ? params[:order_by] : 'created_at'
    @applicants = InnovateApplicant.order("#{order_by} DESC")

    if params[:status].present?
      @applicants = @applicants.where(status: InnovateApplicant.statuses[params[:status]])
    end

    if params[:q].present?
      @applicants = @applicants.where("first_name ILIKE :q OR last_name ILIKE :q OR email ILIKE :q", q: "%#{params[:q]}%")
    end

    @applicants = @applicants.order('created_at DESC')
      .paginate(page: params[:page], per_page: 100)

    @applicants_count = @applicants.count
  end

  def show
    @applicant = InnovateApplicant.find(params[:id])
  end

  def aplication_params
    params.require(:top_applicant).permit(:comment)
  end
end
