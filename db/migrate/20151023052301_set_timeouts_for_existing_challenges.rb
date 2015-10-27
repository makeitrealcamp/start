class SetTimeoutsForExistingChallenges < ActiveRecord::Migration
  def change
    Challenge.evaluation_strategies.keys.each do |strategy|
      timeout = Challenge.default_timeout_for_evaluation_strategy(strategy)
      Challenge.send(strategy).update_all(timeout: timeout)
    end
  end
end
