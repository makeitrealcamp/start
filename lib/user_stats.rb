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

  def level_progress
    points_next_level = @user.next_level ? @user.next_level.required_points : 0
    return 0 if points_next_level - @user.level.required_points == 0
    (@user.stats.total_points - @user.level.required_points).to_f/(points_next_level - @user.level.required_points).to_f
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

  def completed_projects_by_course_count(course)
    completed_projects_by_course(course).count
  end

  def points_needed_for_next_level

    if @user.next_level
      @user.next_level.required_points - @user.stats.total_points
    else
      @user.stats.total_points
    end
  end

  def badges_count
    # + 1 badge 'hago parte de make it real'
    @user.badges.count + 1
  end

  def total_points
    @user.points.sum(:points)
  end

  def points_per_course(course)
    @user.points.where(course: course).sum(:points)
  end

  def solved_challenges(beginning_of_week, end_of_week)
    Challenge.where(id: @user.solutions.completed_at_after(beginning_of_week).completed_at_before(end_of_week).pluck(:challenge_id))
  end

  def completed_resources(beginning_of_week, end_of_week)
    Resource.where(id: @user.resource_completions.created_at_after(beginning_of_week).created_at_before(end_of_week).pluck(:resource_id))
  end

  def finished_projects(beginning_of_week, end_of_week)
    Project.where(id: @user.project_solutions.created_at_after(beginning_of_week).created_at_before(end_of_week).pluck(:project_id))
  end

  def received_badges(beginning_of_week, end_of_week)
    Badge.where(id: @user.badge_ownerships.created_at_after(beginning_of_week).created_at_before(end_of_week).pluck(:badge_id))
  end

  def received_points(beginning_of_week, end_of_week)
    @user.points.created_at_after(beginning_of_week).created_at_before(end_of_week)
  end


  private
    def completed_resources_by_course(course)
      @user.resources.published.where(course_id: course.id)
    end

    def completed_challenges_by_course(course)
      @user.completed_challenges.published.where(course_id: course.id)
    end

    def completed_projects_by_course(course)
      @user.projects.published.where(course_id: course.id)
    end

end
