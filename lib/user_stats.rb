class UserStats
  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def progress_by_course(course)
    resources_count = course.resources.published.count
    challenges_count = course.challenges.published.count
    total = resources_count + challenges_count
    return 1.0 if total == 0

    user_completed = completed_resources_by_course_count(course) + completed_challenges_by_course_count(course)
    user_completed.to_f/total.to_f
  end

  def completed_resources_count
    @user.resources.published.count
  end

  def completed_resources_by_course_count(course)
    completed_resources_by_course(course).count
  end

  def completed_challenges_count
    @user.completed_challenges.published.count
  end

  def completed_challenges_by_course_count(course)
    completed_challenges_by_course(course).count
  end

  def completed_projects_count
    @user.projects.published.count
  end


  def badges_count
    #TODO: implement badges module
    # By now everyone has the "Hago parte de MIR" badge
    1
  end

  private

  def completed_resources_by_course(course)
    @user.resources.published.where(course_id: course.id)
  end

  def completed_challenges_by_course(course)
    @user.completed_challenges.published.where(course_id: course.id)
  end

end
