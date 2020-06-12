class Admin::SpeakersController < ApplicationController
  before_action :admin_access

  def new
    webinar = Webinars::Webinar.find(params[:webinar_id])
    @speaker = webinar.speakers.new
  end

  def create
    webinar = Webinars::Webinar.find(params[:webinar_id])
    @speaker = webinar.speakers.create(speaker_params)
  end

  def destroy
    @webinar = Webinars::Webinar.find(params[:webinar_id])
    @speaker = @webinar.speakers.find(params[:id])
    @speaker.destroy
  end

  private
    def speaker_params
      params.require(:webinars_speaker).permit(:name, :bio, :avatar)
    end
end
