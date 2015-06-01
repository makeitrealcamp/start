class FormsController < ApplicationController
  def hello
    client = Octokit::Client.new(client_id: ENV['GITHUB_KEY'], client_secret: ENV['GITHUB_SECRET'])
    @content = client.contents("makeitrealcamp/misc-content", path: "css-display.md", accept: "application/vnd.github.VERSION.raw").encode("ASCII-8BIT").force_encoding("utf-8")
  end
end