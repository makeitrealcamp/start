class PagesController < ApplicationController
  before_action :public_access, except: [:handbook]

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


  def curriculum
  end

  def full_stack_web_developer
  end

  def front_end_web_developer
  end

  def faq
  end

  def thanks
  end

  def makers
  end

  def pricing
  end

  def publicar
    
  end

end
