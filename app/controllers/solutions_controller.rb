class SolutionsController < ApplicationController
  before_action :private_access

  def submit
    @solution = Solution.find(params[:id])
    update_documents
    evaluate_solution
  end

  private
    def update_documents
      @solution.documents.each { |doc| doc.update(content: params["content-#{doc.id}"]) }
    end

    def evaluate_solution
      @error = @solution.evaluate
      @status = @error ? :failed : :completed
    end
end
