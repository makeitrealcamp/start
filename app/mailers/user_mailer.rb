class UserMailer < ApplicationMailer

  def password_reset(user)
    @user = user
    mail to: @user.email, subject: "Reestablecer Contraseña"
  end

  def inscription_info(user)
    @user = user
    mail to: @user.email, subject: "¿Quieres aprender a crear tus propias aplicaciones Web?"
  end

  def activate(user)
    @user = user
    mail to: @user.email, subject: "Por favor active su cuenta en  Make it Real"
  end

  def project_solution_notification(admin, solution)
    @user = admin
    @solution = solution
    @maker = solution.user
    @project = solution.project
    mail to: @user.email, subject: "El maker #{@maker.email} hizo una solución al proyecto #{@project.name} "
  end
end
