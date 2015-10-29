crumb :root do
  link "Inicio", root_path
end

crumb :courses do
  link "Temas", courses_path
end

crumb :course do |course|
  link course.name, course
  parent :courses
end

crumb :challenges do |course|
  link "Retos", course_path(course, tab: "challenges")
  parent :course, course
end

crumb :challenge do |challenge|
  link challenge.name, course_challenge_path(challenge.course,challenge)
  parent :challenges, challenge.course
end

crumb :challenge_discussion do |challenge|
  link "Discusión"
  parent :challenge, challenge
end

crumb :resources do |course|
  link "Recursos", course_path(course, tab: "resources")
  parent :course, course
end

crumb :resource do |resource|
  link resource.title, resource
  parent :resources, resource.course
end

crumb :projects do |course|
  link "Proyectos", course_path(course, tab: "projects")
  parent :course, course
end

crumb :project do |project|
  link project.name, [project.course, project]
  parent :projects, project.course
end

crumb :project_solutions do |project|
  link "Soluciones", course_project_project_solutions_path(project.course, project)
  parent :project, project
end

crumb :project_solution do |project_solution|
  link "Solución de #{project_solution.user.first_name}"
  parent :project_solutions, project_solution.project
end

crumb :quizzes do |course|
  link "Quizzes", course_path(course, tab: "quizzes")
  parent :course, course
end

crumb :quiz do |quiz|
  link quiz.name, [quiz.course, quiz]
  parent :quizzes, quiz.course
end

crumb :quiz_questions do |quiz|
  link "Preguntas"
  parent :quiz, quiz
end

crumb :quiz_attempt do |quiz|
  link "Intentar Quiz"
  parent :quiz, quiz
end

crumb :quiz_result do |quiz|
  link "Resultado"
  parent :quiz, quiz
end
