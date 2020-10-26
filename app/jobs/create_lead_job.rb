class CreateLeadJob < ActiveJob::Base
  queue_as :default

  def perform(data)
    pid = data[:pid]
    first_name = data[:first_name]
    last_name = data[:last_name]
    email = data[:email]
    country = data[:country]
    source = data[:source]

    person = { pid: pid, email: email, first_name: first_name, last_name: last_name,
        country_code: country, source: source, ip: data[:ip] }
    begin
      ConvertLoop.event_logs.send(name: data[:event], person: person)
    rescue => e
      Rails.logger.error "Couldn't send event #{data[:event]} to ConvertLoop: #{e.message}"
    end

    AdminMailer.new_lead(data[:program], first_name, last_name, email, country,
        source).deliver_now
  end
end
