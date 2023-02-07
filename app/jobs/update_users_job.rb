class UpdateUsersJob < ActiveJob::Base
  def perform
    @applicants = Applicant.where("info -> 'aspiring_course_accepted' = ?", "true")
    @applicants.update_all("status = 15")
    @applicants.each do |applicant|
      ConvertLoopJob.perform_later({ name: "Confirmed to Aspirantes TOP", email: applicant.email }.merge(pid: cookies[:dp_pid]))
    end
  end
end

#run the job
UpdateUsersJob.perform()
