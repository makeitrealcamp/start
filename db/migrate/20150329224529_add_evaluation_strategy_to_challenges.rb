class AddEvaluationStrategyToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :evaluation_strategy, :integer

    reversible do |dir|
      dir.up do
        Challenge.update_all(evaluation_strategy: 0)
      end
    end
  end
end
