class AddVideoDurationToLesson < ActiveRecord::Migration
  def change

    add_column :lessons, :video_duration, :string
  end
end
