class Admin::TopCohortsController < ApplicationController
  before_action :admin_access

  def index
    @cohorts = TopCohort.order(created_at: :desc)
  end

  def new
    @cohort = TopCohort.new
  end

  def create
    @cohort = TopCohort.create(cohort_params)
  end

  def edit
    @cohort = TopCohort.find(params[:id])
  end

  def update
    @cohort = TopCohort.find(params[:id])
    @cohort.update(cohort_params)
  end

  private
    def cohort_params
      params.require(:top_cohort).permit(:name)
    end
end
