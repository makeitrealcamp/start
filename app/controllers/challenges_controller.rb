class ChallengesController < ApplicationController
  before_action :private_access

  def show
    @challenge = Challenge.friendly.find(params[:id])
    @user = current_user
    paid_access
    @solution = load_solution
  end

  def discussion
    @challenge = Challenge.friendly.find(params[:id])
    solution = load_solution
    if (solution.nil? || solution.completed_at.blank?) && !current_user.is_admin?
      flash[:error] = "Debes completar el reto para poder ver la discusión"
      redirect_to subject_challenge_path(@challenge.subject, @challenge)
    end
  end

  private
    def load_solution
      current_user.solutions.where(challenge_id: @challenge.id).take
    end

end
