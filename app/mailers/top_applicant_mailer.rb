class TopApplicantMailer < ApplicationMailer
	include Roadie::Rails::Automatic
    default from: "german.escobar@makeitreal.camp"
	def ApplicationActivity(user,subject,body)
		@body = body
		@user = user
		mail to: user.email, subject: "Hola"
	end
end
