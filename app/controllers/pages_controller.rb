class PagesController < ApplicationController
  before_action :public_access, except: [:handbook]

  def home
    @user = User.new
  end

  def handbook
    @content = Octokit.contents("makeitrealcamp/handbook", path: "README.md", accept: "application/vnd.github.VERSION.raw").encode("ASCII-8BIT").force_encoding("utf-8")
  end

end
