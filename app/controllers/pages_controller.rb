class PagesController < ApplicationController
  before_action :public_access, except: [:handbook]
  before_action :save_referer, except: [:handbook]

  def home
  end

  def handbook
    client = Octokit::Client.new(
      client_id:     ENV['GITHUB_KEY'],
      client_secret: ENV['GITHUB_SECRET']
    )
    @content = client.contents(
        "makeitrealcamp/handbook",
        path: "README.md", accept: "application/vnd.github.VERSION.raw"
      ).encode("ASCII-8BIT").force_encoding("utf-8")

    render layout: "application"
  end

  def front_end_bootcamp
    @typeform_url = "https://makeitreal.typeform.com/to/Cr9SSv?referer=#{session['referer']}"
  end

  def send_web_developer_guide
    PagesMailer.web_developer_guide(SubscriberForm.new(params)).deliver_now

    render :web_developer_guide
  end

  private
    def save_referer
      session['referer'] = request.env["HTTP_REFERER"] || 'none' unless session['referer']
    end

end
