namespace :send_email do
  desc 'send weekly email'
  task weekly_email: :environment do
    users = User.paid_account
    date_week = Time.now - 1.week

    users.each do |user|
      challenges_completed = user.solutions.completed.where(created_at: date_week..Time.now).count
      resources_completed =  user.resources.published.where(created_at: date_week..Time.now).count
      UserMailer.weekly_email(user, challenges_completed, resources_completed).deliver_now
    end
  end
end
