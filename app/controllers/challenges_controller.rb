class ChallengesController < ApplicationController
  def show
    @challenge = Challenge.find(params[:id])
    @solution = find_or_create_solution
  end

  private
    def find_or_create_solution
      find_solution || create_solution
    end

    def find_solution
      current_user.solutions.where(challenge_id: @challenge.id).take
    end

    def create_solution
      current_user.solutions.create(challenge: @challenge)
    end
end
