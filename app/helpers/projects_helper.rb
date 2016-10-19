module ProjectsHelper
  def project_solution_form_url
    if @project_solution.new_record?
     subject_project_project_solutions_path(@project.subject,@project)
   else
     subject_project_project_solution_path(@project.subject,@project,@project_solution)
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
