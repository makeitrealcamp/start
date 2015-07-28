namespace :mir do
  desc "Recalculate points, badges and user's level based on challenges solutions"
  task recalc_badges_and_points: :environment do

    ActiveRecord::Base.transaction do
      Point.where(pointable_type: "Challenge").destroy_all
      ChallengeCompletion.destroy_all
      Solution.completed.find_each do |sol|
        sol.create_user_points!
      end
    end
  end

end
