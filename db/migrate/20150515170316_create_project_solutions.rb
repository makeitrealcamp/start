class CreateProjectSolutions < ActiveRecord::Migration
  def change
    create_table :project_solutions do |t|
      t.references :user, index: true
      t.references :project, index: true
      t.string :repository
      t.string :url
      t.text :summary

      t.timestamps null: false
    end
    add_foreign_key :project_solutions, :users
    add_foreign_key :project_solutions, :projects
  end
end
