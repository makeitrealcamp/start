crumb :root do
  link "Inicio", dashboard_path
end

crumb :subjects do
  link "Temas", subjects_path
end

crumb :subject do |subject|
  link subject.name, subject
  parent :subjects
end

crumb :challenges do |subject|
  link "Retos", subject_path(subject, tab: "challenges")
  parent :subject, subject
end

crumb :challenge do |challenge|
  link challenge.name, subject_challenge_path(challenge.subject,challenge)
  parent :challenges, challenge.subject
end

crumb :challenge_discussion do |challenge|
  link "Discusión"
  parent :challenge, challenge
end

crumb :resources do |subject|
  link "Recursos", subject_path(subject, tab: "resources")
  parent :subject, subject
end

crumb :resource do |resource|
  link resource.title, resource
  parent :resources, resource.subject
end

crumb :projects do |subject|
  link "Proyectos", subject_path(subject, tab: "projects")
  parent :subject, subject
end

crumb :project do |project|
  link project.name, [project.subject, project]
  parent :projects, project.subject
end

crumb :project_solutions do |project|
  link "Soluciones", subject_project_project_solutions_path(project.subject, project)
  parent :project, project
end

crumb :project_solution do |project_solution|
  link "Solución de #{project_solution.user.first_name}"
  parent :project_solutions, project_solution.project
end

crumb :quiz do |quiz|
  link quiz.title, [quiz.subject, quiz]
  parent :resources, quiz.subject
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
