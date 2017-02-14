class UserMailer < ApplicationMailer
  include Roadie::Rails::Automatic

  def password_reset(user)
    @user = user
    mail to: @user.email, subject: "Reestablecer Contraseña"
  end

  def project_solution_notification(admin, solution)
    @user = admin
    @solution = solution
    @maker = solution.user
    @project = solution.project
    mail to: @user.email, subject: "[Solución] #{@maker.name} hizo una solución al proyecto #{@project.name} "
  end

  def weekly_summary_email(user)
    date = DateTime.current
    beginning_of_week = date.beginning_of_week
    end_of_week = date.end_of_week
    @user = user

    @solved_challenges = user.stats.solved_challenges(beginning_of_week, end_of_week)
    @completed_resources = user.stats.completed_resources(beginning_of_week, end_of_week)
    @finished_projects = user.stats.finished_projects(beginning_of_week, end_of_week)
    @received_badges = user.stats.received_badges(beginning_of_week, end_of_week)
    @received_points = user.stats.received_points(beginning_of_week, end_of_week)

    @unread_notifications = user.notifications.unread
    @points_needed_for_next_level = user.stats.points_needed_for_next_level
    mail to: @user.email, subject: "Un resumen de tu semana en Make it Real"
  end

  def comment_response(comment)
    @user = comment.response_to.user
    @comment = comment

    mail to: @user.email, subject: "Tienes una nueva respuesta en tu comentario"
  end

  def charge_instructions(charge)
    @charge = charge

    mail to: charge.email, subject: "Instrucciones de pago"
  end

  def charge_validation(charge)
    @charge = charge

    mail to: charge.email, subject: "Pago en proceso de validación"
  end

  def charge_rejected(charge)
    @charge = charge

    mail to: charge.email, subject: "Pago rechazado por la entidad financiera"
  end
end
