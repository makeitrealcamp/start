ActionMailer::Base.smtp_settings = {
  :port           => '25',
  :address        => ENV['POSTMARK_SMTP_SERVER'] || "smtp.postmarkapp.com",
  :user_name      => ENV['POSTMARK_API_KEY'] || "b24c59a9-ac8b-4b47-bcea-ae212dde91c7",
  :password       => ENV['POSTMARK_API_KEY'] || "b24c59a9-ac8b-4b47-bcea-ae212dde91c7",
  :domain         => ENV['HOSTNAME'] || "",
  :authentication => :plain
}

ActionMailer::Base.default_url_options[:host] = ENV["HOSTNAME"] || "localhost:3000"
