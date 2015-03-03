module CoursesHelper
  def challenge_class(challenge)
    challenge_completed?(challenge) ? "completed" : "not-completed"
  end

  private
    def challenge_completed?(challenge)
      solution = current_user.solutions.where(challenge_id: challenge.id).take
      solution && solution.status == "completed"
    end
end
