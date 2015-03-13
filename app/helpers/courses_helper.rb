module CoursesHelper
  def challenge_class(challenge)
    challenge_completed?(challenge) ? "completed" : "not-completed"
  end

  def link_to_toggle_completed(resource)
    css_class = ""
    method = :post
    if resource.users.include?(current_user)
      css_class = "completed"
      method = :delete
    end

    link_to "<span class='glyphicon glyphicon-ok-circle'></span>".html_safe, course_resource_completion_path(course_id: resource.course.id, resource_id: resource.id), class: "resource-status #{css_class}", data: { "resource-id" => resource.id }, remote: true, method: method
  end

  private
    def challenge_completed?(challenge)
      solution = current_user.solutions.where(challenge_id: challenge.id).take
      solution && solution.status == "completed"
    end
end