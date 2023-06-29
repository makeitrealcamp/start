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
    linkedin = data[:linkedin]
    goal = data[:goal]
    experience = data[:experience]
    additional =  data[:additional]
    format = data[:format]
    payment_method = data[:payment_method]
    stipend = data[:stipend]
    user_id_type = data[:docType]
    user_id = data[:docNumber]
    studies = data[:studies]
    working = data[:working]
    document_number = data[:document_number]
    document_type = data[:document_type]
    accepted_terms= data[:accepted_terms]

    person = { pid: pid, email: email, first_name: first_name, last_name: last_name,
        country_code: country, mobile: mobile, birthday: birthday, gender: gender ,source: source, 
        linkedin: linkedin, goal: goal, experience: experience, additional: additional, studies: studies, working: working, format: format,
        payment_method: payment_method, stipend: stipend, user_id_type: user_id_type, user_id: user_id, document_type: document_type, document_number: document_number, accepted_terms: accepted_terms }
    begin
      ConvertLoop.event_logs.send(name: data[:event], person: person, metadata: { ip: data[:ip] })
    rescue => e
      Rails.logger.error "Couldn't send event #{data[:event]} to ConvertLoop: #{e.message}"
    end

    AdminMailer.new_lead(data[:program], first_name, last_name, email, country, mobile,
        source).deliver_now
  end
end