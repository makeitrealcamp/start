class Admin::WebinarsController < ApplicationController
  before_action :admin_access

  def index
    @upcoming = Webinars::Webinar.upcoming
    @past = Webinars::Webinar.past
  end

  def new
    @webinar = Webinars::Webinar.new(date: DateTime.current.change({ hour: 23, minute: 0 }))
  end

  def create
    date = DateTime.parse("#{webinar_params[:date]} #{params[:time]} -05").utc
    @webinar = Webinars::Webinar.create(webinar_params.merge(date: date))

    redirect_to admin_webinars_path
  end

  def edit
    @webinar = Webinars::Webinar.find(params[:id])
  end

  def update
    @webinar = Webinars::Webinar.find(params[:id])
    date = DateTime.parse("#{webinar_params[:date]} #{params[:time]} -05").utc
    @webinar.update(webinar_params.merge(date: date))

    redirect_to admin_webinars_path
  end

  def show
    @webinar = Webinars::Webinar.find(params[:id])
  end

  def destroy
    @webinar = Webinars::Webinar.find(params[:id])
    @webinar.destroy

    redirect_to admin_webinars_path
  end

  private
    def webinar_params
      params.require(:webinars_webinar).permit(:title, :slug, :date, :description, :image_url, :event_url)
    end
end
