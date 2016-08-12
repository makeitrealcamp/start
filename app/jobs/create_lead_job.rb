class CreateLeadJob < ActiveJob::Base
  queue_as :default

  def perform(data)
    first_name = data[:first_name]
    last_name = data[:last_name]
    email = data[:email]
    country = data[:country]
    mobile = data[:mobile]

    person = { email: email, first_name: first_name, last_name: last_name,
        country_code: country, mobile: mobile, ip: data[:ip] }
    ConvertLoop.event_logs.send(name: data[:event], person: person)

    AdminMailer.new_lead(data[:program], first_name, last_name, email, country,
        mobile).deliver_now
  end
end
