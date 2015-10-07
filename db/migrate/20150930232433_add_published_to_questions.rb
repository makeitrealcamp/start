class AddPublishedToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :published, :boolean
  end
end
