class Admin::ChallengesController < ApplicationController
  before_action :admin_access

  # GET /admin/challenges
  def index
    @paths = Path.all
    @challenges = Challenge.published
    if !params[:subject_id].blank?
      @challenges = @challenges.where(subject_id: params[:subject_id])
    else
      @challenges = @challenges.order("updated_at DESC")
    end

    @challenges = @challenges.limit(100)
  end

  #GET /admin/subjects/:subject_id/challenges/new
  def new
    subject = Subject.friendly.find(params[:subject_id])
    @challenge = subject.challenges.new
  end

  def create
    @challenge = Challenge.create(challenge_params)
    redirect_to subject_path(@challenge.subject), notice: "El reto <strong>#{@challenge.name}</strong> ha sido creado"
  end

  def edit
    @challenge = Challenge.friendly.find(params[:id])
  end

  def destroy
    @challenge = Challenge.friendly.find(params[:id])
    @challenge.destroy
  end

  def update
    @challenge = Challenge.friendly.update(params[:id], challenge_params)
    redirect_to subject_challenge_path(@challenge.subject,@challenge), notice: "El reto <strong>#{@challenge.name}</strong> ha sido actualizado"
  end

  def update_position
    @content = Challenge.update(params[:id], row_position: params[:position])
    render nothing: true, status: 200
  end

  private
    def challenge_params
      params.require(:challenge).permit(
        :subject_id, :name, :instructions, :evaluation_strategy, :published, :timeout,
        :evaluation, :solution_text, :solution_video_url,:difficulty_bonus, :restricted, :preview, :pair_programming,
        documents_attributes: [:id, :name, :content, :_destroy])
    end

    def paid_access
      super if @challenge.restricted?
    end

end
