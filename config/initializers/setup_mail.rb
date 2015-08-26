ActionMailer::Base.smtp_settings = {
  :port           => '25',
  :address        => ENV['POSTMARK_SMTP_SERVER'] || "smtp.postmarkapp.com",
  :user_name      => ENV['POSTMARK_API_KEY'],
  :password       => ENV['POSTMARK_API_KEY'],
  :domain         => ENV['HOSTNAME'] || "",
  :authentication => :plain
}

ActionMailer::Base.default_url_options[:host] = ENV["HOSTNAME"] || "localhost:3000"
