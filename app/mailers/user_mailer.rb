class UserMailer < ApplicationMailer
  include Roadie::Rails::Automatic

  def inscription_info(user)
    @user = user
    mail to: @user.email, subject: "¿Quieres aprender a crear tus propias aplicaciones Web?"
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

    @solved_challenges = user.stats.solved_challenges(beginning_of_week, end_of_week)
    @completed_resources = user.stats.completed_resources(beginning_of_week, end_of_week)
    @finished_projects = user.stats.finished_projects(beginning_of_week, end_of_week)
    @received_badges = user.stats.received_badges(beginning_of_week, end_of_week)
    @received_points = user.stats.received_points(beginning_of_week, end_of_week)

    @unread_notifications = user.notifications.unread
    @points_needed_for_next_level = user.stats.points_needed_for_next_level
    mail to: @user.email, subject: "Un resumen de tu semana en Make it Real"
  end
end
