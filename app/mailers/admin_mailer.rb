class AdminMailer < ApplicationMailer
  include Roadie::Rails::Automatic

  def new_lead(program, first_name, last_name, email, country, mobile)
    @program = program
    @first_name = first_name
    @last_name = last_name
    @email = email
    @country = country
    @mobile = mobile

    mail to: "carolina.hernandez@makeitreal.camp", subject: "[Nuevo Lead #{program}] #{first_name} #{last_name} (#{country}: #{mobile})"
  end
end
