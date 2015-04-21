class AddSolutionVideoUrlAndSolutionTextToChallenge < ActiveRecord::Migration
  def change
    add_column :challenges, :solution_video_url, :string
    add_column :challenges, :solution_text, :text
  end
end
