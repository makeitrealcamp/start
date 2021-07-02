class CreateLeadJob < ActiveJob::Base
  queue_as :default

  def perform(data)
    pid = data[:pid]
    first_name = data[:first_name]
    last_name = data[:last_name]
    email = data[:email]
    country = data[:country]
    mobile = data[:mobile]
    birthday = data[:birthday]
    gender = data[:gender]
    source = data[:source]

    person = { pid: pid, email: email, first_name: first_name, last_name: last_name,
        country_code: country, mobile: mobile, birthday: birthday, gender: gender ,source: source }
    begin
      ConvertLoop.event_logs.send(name: data[:event], person: person, metadata: { ip: data[:ip] })
    rescue => e
      Rails.logger.error "Couldn't send event #{data[:event]} to ConvertLoop: #{e.message}"
    end

    AdminMailer.new_lead(data[:program], first_name, last_name, email, country, mobile,
        source).deliver_now
  end
end
