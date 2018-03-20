class Admin::TopApplicantTestsController < ApplicationController
  before_action :admin_access

  def show
    @test = TopApplicantTest.find(params[:id])
  end
end
