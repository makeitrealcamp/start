class PagesController < ApplicationController
  before_action :public_access, except: [:handbook]

  def home
    @home = true
  end

  def handbook
    client = Octokit::Client.new(client_id: ENV['GITHUB_KEY'], client_secret: ENV['GITHUB_SECRET'])
    @content = client.contents("makeitrealcamp/handbook", path: "README.md", accept: "application/vnd.github.VERSION.raw").encode("ASCII-8BIT").force_encoding("utf-8")
  end

  def new_home
    render layout: false
  end

  def curriculum
    render layout: false
  end

end
