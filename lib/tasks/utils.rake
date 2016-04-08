namespace :utils do
  desc "Clears and populates activity table"
  task populate_activity_table: :environment do
    ActivityLog.delete_all

    User.active.each do |user|
      created_at = user.activated_at || user.created_at
      ActivityLog.create(user: user, description: "Inició el programa", created_at: created_at)
    end

    ResourceCompletion.all.each do |resource_completion|
      resource = resource_completion.resource

      if resource.url?
        description = "Abrió el recurso externo #{resource.to_html_description}"
        ActivityLog.create(user: resource_completion.user, activity: resource, description: description, created_at: resource_completion.created_at)
      elsif resource.markdown?
        description = "Abrió el recurso interno #{resource.to_html_description}"
        ActivityLog.create(user: resource_completion.user, activity: resource, description: description, created_at: resource_completion.created_at)
      end
    end

    LessonCompletion.all.each do |lesson_completion|
      lesson = lesson_completion.lesson

      description = "Completó #{lesson.to_html_description}"
      ActivityLog.create(user: lesson_completion.user, activity: lesson, description: description, created_at: lesson_completion.created_at)
    end

    Solution.all.each do |solution|
      description = "Inició #{solution.challenge.to_html_description}"
      ActivityLog.create(user: solution.user, activity: solution, description: description, created_at: solution.created_at)
    end

    Comment.all.each do |comment|
      description = "Comentó en #{comment.commentable.to_html_description}"
      ActivityLog.create(user: comment.user, activity: comment, description: description, created_at: comment.created_at)
    end

    ProjectSolution.all.each do |project_solution|
      project = project_solution.project

      description = "Envió una solución a #{project.to_html_description}"
      ActivityLog.create(user: project_solution.user, activity: project_solution, description: description, created_at: project_solution.created_at)
    end

    Quizer::QuizAttempt.all.each do |quiz_attempt|
      quiz = quiz_attempt.quiz

      description = "Inició #{quiz.to_html_description}"
      ActivityLog.create(user: quiz_attempt.user, activity: quiz_attempt, description: description, created_at: quiz_attempt.created_at)

      if quiz_attempt.finished?
        description = "Finalió #{quiz.to_html_description} con un puntaje de #{quiz_attempt.score}"
        ActivityLog.create(user: quiz_attempt.user, activity: quiz_attempt, description: description, created_at: quiz_attempt.updated_at)
      end
    end
  end
end
