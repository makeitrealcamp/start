class AdminMailer < ApplicationMailer
  include Roadie::Rails::Automatic

  def new_lead(program, first_name, last_name, email, country, mobile)
    @program = program
    @first_name = first_name
    @last_name = last_name
    @email = email
    @country = country
    @mobile = mobile

    mail to: "nicolas.rodriguez@makeitreal.camp", subject: "[Nuevo Lead #{program}] #{first_name} #{last_name} (#{country}: #{mobile})"
  end

  def new_scholarship(data)
    @data = data

    mail to: "diana.vanegas@makeitreal.camp", subject: "[Beca] #{@data[:person][:first_name]} #{@data[:person][:last_name]}"
  end

  def new_comment(email, admin, comment)
    @user = admin
    @comment = comment

    mail to: email, subject: "#{@comment.user.name} ha dejado un comentario en #{@comment.commentable.to_s}"
  end

  def top_test_submitted(applicant)
    @email = applicant.email
    @first_name = applicant.first_name
    @last_name = applicant.last_name

    mail to: "german.escobar@makeitreal.camp", subject: "[Top Program] Test submitted"
  end
end
