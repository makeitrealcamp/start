namespace :mir do
  desc "Recalculate points, badges and user's level based on challenges solutions"
  task recalc_badges_and_points: :environment do

    ActiveRecord::Base.transaction do
      Point.where(pointable_type: "Challenge").destroy_all
      ChallengeCompletion.destroy_all
      Solution.completed.find_each do |sol|
        sol.create_user_points! if sol.challenge.published?
      end
    end
  end

  desc "Create default badges"
  task create_badges: :environment do
    levels = ["Padawan", "Caballero Jedi", "Maestro Jedi"]

    badges_data = {
      "HTML y CSS" => [2,3,4],
      "Bootstrap 3" => [5,6,7],
      "Git y Github" => [8,9,10],
      "Ruby básico" => [11,12,13],
      "Intro to Web Development" => [14,15,16],
      "Ruby on Rails I" => [17,18,19],
      "Ruby on Rails II" => [20,21,22],
      "Javascript" => [23,24,25],
      "jQuery y AJAX" => [26,27,28]
    }
    ActiveRecord::Base.transaction do
      badges_data.each do |subject_name,url_nums|
        if c = Subject.find_by_name(subject_name)
          url_nums.each_with_index do |url_num, i|
            c.badges.create(
              name: "#{subject_name} #{levels[i]}",
              giving_method: "points",
              required_points: 30000, # Required points should be adjusted manually after running this script
              image_url: "https://s3.amazonaws.com/makeitreal/badges/emblem_mir_#{'%02d' % url_num}%402x.png"
            )
          end
        end
      end

      Badge.create(name: "Primer pair programming", giving_method: "manually", image_url: "https://s3.amazonaws.com/makeitreal/badges/emblem_mir_29%402x.png")
      Badge.create(name: "Code challenge breaker", giving_method: "manually", image_url: "https://s3.amazonaws.com/makeitreal/badges/emblem_mir_30%402x.png")
      Badge.create(name: "Primer deploy", giving_method: "manually", image_url: "https://s3.amazonaws.com/makeitreal/badges/emblem_mir_31%402x.png")
    end
  end

  desc "Send summary email to students"
  task :send_summary_email,[:day] => [:environment] do |t,args|
    args.with_defaults(:day => "sunday")
    if DateTime.current.send("#{args[:day]}?")
      students = User.where(status: User.statuses[:active], account_type: [User.account_types[:paid_account], User.account_types[:admin_account]]).is_activity_email
      students.each do |u|
        UserMailer.weekly_summary_email(u).deliver_now if u.has_weekly_points?
      end
    end
  end

end
