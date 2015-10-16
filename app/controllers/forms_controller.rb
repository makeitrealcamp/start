class FormsController < ApplicationController
  def hello
    client = Octokit::Client.new(client_id: ENV['GITHUB_KEY'], client_secret: ENV['GITHUB_SECRET'])
    @content = client.contents("makeitrealcamp/misc-content", path: "css-display.md", accept: "application/vnd.github.VERSION.raw").encode("ASCII-8BIT").force_encoding("utf-8")
  end

  def slack_help
    client = Slack::Web::Client.new(token: ENV['slack_token'])
    client.chat_postMessage(channel: ENV['mentor_channel_id'], text: params[:message], username: current_user.first_name.capitalize)
    flash[:notice] = "Hemos enviado tu mensaje pronto un mentor te ayudara via Slack"
    redirect_to(:back)
  end
end
