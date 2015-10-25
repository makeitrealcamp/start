class DashboardController < ApplicationController
  def index
    @challenge = current_user.next_challenge
    @is_new_challenge = solution_to(@challenge).nil?
    @pending_challenges = current_user.solutions.pending.joins(:challenge)
        .where('challenges.published = ?', true)
        .where('challenge_id <> ?', @challenge.try(:id))
        .shuffle.map(&:challenge).first(3)
  end

  private
    def solution_to(challenge)
      current_user.solutions.where(challenge: challenge).take
    end
end
