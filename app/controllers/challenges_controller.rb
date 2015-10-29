class ChallengesController < ApplicationController
  before_action :private_access
  before_action :admin_access, except:[:show, :discussion]

  def new
    course = Course.friendly.find(params[:course_id])
    @challenge = course.challenges.new
  end

  def create
    @challenge = Challenge.create(challenge_params)
    redirect_to course_path(@challenge.course), notice: "El reto <strong>#{@challenge.name}</strong> ha sido creado"
  end

  def edit
    @challenge = Challenge.friendly.find(params[:id])
  end

  def update
    @challenge = Challenge.friendly.update(params[:id], challenge_params)
    redirect_to course_challenge_path(@challenge.course,@challenge), notice: "El reto <strong>#{@challenge.name}</strong> ha sido actualizado"
  end

  def update_position
    @content = Challenge.update(params[:id], row_position: params[:position])
    render nothing: true, status: 200
  end

  def show
    @challenge = Challenge.friendly.find(params[:id])
    @user = current_user
    paid_access
    @solution = load_solution
  end

  def destroy
    @challenge = Challenge.friendly.find(params[:id])
    @challenge.destroy
  end

  def discussion
    @challenge = Challenge.friendly.find(params[:id])
    solution = load_solution
    if (solution.nil? || solution.completed_at.blank?) && !current_user.is_admin?
      flash[:error] = "Debes completar el reto para poder ver la discusión"
      redirect_to course_challenge_path(@challenge.course, @challenge)
    end
  end

  private
    def load_solution
      current_user.solutions.where(challenge_id: @challenge.id).take
    end

    def challenge_params
      params.require(:challenge).permit(
        :course_id, :name, :instructions, :evaluation_strategy, :published, :timeout,
        :evaluation, :solution_text, :solution_video_url,:difficulty_bonus, :restricted, :preview, :pair_programming,
        documents_attributes: [:id, :name, :content, :_destroy])
    end

    def paid_access
      super if @challenge.restricted?
    end

end
