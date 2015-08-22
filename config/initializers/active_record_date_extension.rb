Rails.application.config.after_initialize do
  require "active_record_date_extension"
end
