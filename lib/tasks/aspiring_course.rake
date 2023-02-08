require 'rake'

namespace :aspiring_course do
  desc "Update users with aspiring course accepted"
  task :update_all => :environment do
    @applicants = Applicant.where("info -> 'aspiring_course_accepted' = ?", "true").where.not(status: 15)
    
    @applicants.each do |applicant|
      ConvertLoopJob.perform_later({ name: "Confirmed to Aspirantes TOP", email: applicant.email })
    end
    @applicants.update_all("status = 15")
  end
end