class DashboardController < ApplicationController
  def index
    @challenge = current_user.next_challenge
    @is_new_challenge = solution_to(@challenge).nil?
    @pending_challenges = current_user.solutions.pending.joins(:challenge)
        .where('challenges.published = ?', true)
        .where('challenge_id <> ?', @challenge.try(:id))
        .shuffle.map(&:challenge).first(3)

    bow = DateTime.current.beginning_of_week
    @received_points = current_user.points.created_at_after(bow).sum(:points)
    @solved_challenges = Challenge.published.where(id: current_user.solutions.completed_at_after(bow).pluck(:challenge_id)).count
    @completed_resources = Resource.where(id: current_user.resource_completions.created_at_after(bow).pluck(:resource_id)).count
    @finished_projects = Project.where(id: current_user.project_solutions.created_at_after(bow).pluck(:project_id)).count
    @received_badges = Badge.where(id: current_user.badge_ownerships.created_at_after(bow).pluck(:badge_id)).count
  end

  private
    def solution_to(challenge)
      current_user.solutions.where(challenge: challenge).take
    end
end
