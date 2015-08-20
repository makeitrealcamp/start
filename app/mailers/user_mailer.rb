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

  def weekly_summary_email(user)
    date = DateTime.current
    beginning_of_week = date.beginning_of_week
    end_of_week = date.end_of_week
    @user = user
    #TODO: move to UserStats
    @solved_challenges = Challenge.where(id: user.solutions.completed_at_after(beginning_of_week).completed_at_before(end_of_week).pluck(:challenge_id))
    @completed_resources = Resource.where(id: user.resource_completions.created_at_after(beginning_of_week).created_at_before(end_of_week).pluck(:resource_id))
    @finished_projects = Project.where(id: user.project_solutions.created_at_after(beginning_of_week).created_at_before(end_of_week).pluck(:project_id))
    @received_badges = Badge.where(id: user.badge_ownerships.created_at_after(beginning_of_week).created_at_before(end_of_week).pluck(:badge_id))
    @received_points = user.points.created_at_after(beginning_of_week).created_at_before(end_of_week)
    @unread_notifications = user.notifications.unread
    mail to: @user.email, subject: "Un resumen de tu semana en Make it Real"
  end
end
