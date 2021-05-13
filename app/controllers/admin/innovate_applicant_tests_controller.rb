class Admin::InnovateApplicantTestsController < ApplicationController
  before_action :admin_access

  def show
    @test = InnovateApplicantTest.find(params[:id])
  end
end
