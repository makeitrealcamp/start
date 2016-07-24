class CreateLeadJob < ActiveJob::Base
  queue_as :default

  def perform(data)
    first_name = data[:first_name]
    last_name = data[:last_name]
    email = data[:email]
    country = data[:country]
    mobile = data[:mobile]

    intercom = Intercom::Client.new(app_id: ENV['INTERCOM_APP_ID'], api_key: ENV['INTERCOM_KEY'])
    user = intercom.users.create(email: email, name: "#{first_name} #{last_name}",
      custom_attributes: {
        "Country Code" => country,
        "Mobile" => mobile,
        "First Name" => first_name,
        "Last Name" => last_name
      }
    )
    intercom.events.create(
      event_name: data[:event],
      created_at: Time.now.to_i,
      email: email
    )

    AdminMailer.new_lead(data[:program], first_name, last_name, email, country,
        mobile).deliver_now
  end
end
