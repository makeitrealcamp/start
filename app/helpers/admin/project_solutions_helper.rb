module Admin::ProjectSolutionsHelper
  def project_select_options
    options = []
    Subject.all.each do |c|
      options += c.projects.all.map { |p| ["#{c.name} - #{p.name}",p.id] }
    end
    options
  end
end
