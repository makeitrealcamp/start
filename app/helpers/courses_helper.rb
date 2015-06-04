module CoursesHelper
  def progress_bar(opts = {})
    type = (opts[:type] || "success").to_s
    progress = (opts[:progress] || 1).to_f

    opacity = 0.2
    diff = 1.0
    [0.2,0.4,0.6,0.8,1.0].each do |o|
      if (progress-o).abs < diff
        diff = (progress-o).abs
        opacity = o
      end
    end

    %Q(
    <div class="progress">
      <div class="progress-bar progress-bar-#{type}"
        role="progressbar"
        style="width: #{(progress*100).round(2)}%;opacity:#{opacity}">
      </div>
    </div>).html_safe
  end

  def challenge_class(challenge)
    challenge_completed?(challenge) ? "completed" : "not-completed"
  end

  def link_to_toggle_completed(resource)
    css_class = ""
    method = :post
    unless resource.resource_completions.where(user: current_user).blank?
      css_class = "completed"
      method = :delete
    end

    link_to "<span class='glyphicon glyphicon-ok-circle'></span>".html_safe, course_resource_completion_path(course_id: resource.course.id, resource_id: resource.id), class: "resource-status #{css_class}", data: { "resource-id" => resource.id }, remote: true, method: method
  end

  def challenges_msg(course)
    evaluated = current_user.solutions.evaluated.joins(:challenge).where('challenges.course_id = ?', course.id).count
    failed = current_user.solutions.failed.joins(:challenge).where('challenges.course_id = ?', course.id).count
    if evaluated == 0
      "Los retos. ¿#{current_user.gender == "female" ? "Curiosa" : "Curioso"} por conocer el primero? Inténtalo."
    elsif failed > 0
      "Recuerda que si no estás luchando con los retos no estás aprendiendo nada nuevo."
    elsif evaluated == course.challenges.published.count
      "Has completado todos los retos de este curso. ¡Felicitaciones"
    else
      "¿Estás #{current_user.gender == "female" ? "preparada" : "preparado"} para el siguiente reto?"
    end
  end

  def projects_msg(course)
    phrases = [
      "Vas a aprender nuevas habilidades que te van a convertir en un profesional más competitivo.",
      "Vas a tener algo de que hablar en entrevistas de trabajo... o en fiestas.",
      "Hay 2 tipos de personas: Las que hacen y las que ven hacer ¿Cuál quieres ser tú? ;)",
      "Vas a tener algo que hacer cuando estés aburrido con tu trabajo.",
    ]
    "¿Por qué hacer un proyecto? <br /> #{phrases.sample}".html_safe
  end

  private
    def challenge_completed?(challenge)
      solution = current_user.solutions.where(challenge_id: challenge.id).take
      solution && solution.status == "completed"
    end
end
