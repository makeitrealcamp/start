module ProjectsHelper
  def project_solution_form_url
    if @project_solution.new_record?
     course_project_project_solutions_path(@project.course,@project)
   else
     course_project_project_solution_path(@project.course,@project,@project_solution)
   end
  end

  def project_solution_form_method
    if @project_solution.new_record?
      :post
    else
      :patch
    end
  end
  
end
