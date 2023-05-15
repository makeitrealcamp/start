class SolutionsController < ApplicationController
  before_action :private_access, except: [:preview] # we need the preview action to be public for evaluation
  skip_before_action :verify_authenticity_token, only: [:preview]

  def create
    @challenge = Challenge.friendly.find(params[:challenge_id])
    current_user.solutions.create(challenge: @challenge)
    redirect_to subject_challenge_path(@challenge.subject, @challenge)
  end

  def show
    @solution = Solution.find(params[:id])
    render json: @solution.as_json({ include_user_level: true })
  end

  def update_documents
    @solution = Solution.find(params[:id])
    save_documents_with_no_versioning
    head :no_content
  end

  def submit
    @solution = Solution.find(params[:id])
    @solution.update(repository: params[:repository]) if params[:repository]
    @solution.update(pull_request: params[:pull_request]) if params[:pull_request]
    save_documents
    update_solution_without_versioning(@solution)
    EvaluationJob.perform_later(@solution.id)
    head :no_content
  end

  def preview
    response.headers["Cache-Control"] = "no-cache, no-store"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"

    solution = Solution.find(params[:id]).documents.where(name: params[:file]).take
    if solution
      render plain: solution.content, content_type: content_type_file(params[:file])
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  #DELETE /solutions/:id/reset
  def reset
    challenge = Challenge.friendly.find(params[:id])
    solution = current_user.reset_solution(challenge)
    redirect_to  subject_challenge_path(challenge.subject, challenge)
  end

  private
    def update_solution_without_versioning(solution)
      PaperTrail.request.disable_model(Solution)
      solution.status = :evaluating
      solution.attempts = solution.attempts + 1 if solution.completed_at.nil?
      solution.save!
      PaperTrail.request.enable_model(Solution)
    end

    def save_documents
      @solution.documents.each { |doc| doc.update(content: params["content-#{doc.id}"]) }
    end

    def save_documents_with_no_versioning
      Document.paper_trail.disable
      @solution.documents.each do |doc|
        doc.update(content: params["content-#{doc.id}"])
      end
      Document.paper_trail.enable
    end

    def evaluate_solution
      @error = @solution.evaluate
      @status = @error ? :failed : :completed
    end

    def content_type_file(name)
      mode = { "html" => "text/html", "js" => "text/javascript", "rb" => "text/ruby", "css" => "text/css", "sql" => "text/sql" }
      mode[name.split(".")[1]]
    end
end
