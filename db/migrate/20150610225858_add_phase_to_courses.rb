class AddPhaseToCourses < ActiveRecord::Migration
  def change
    add_reference :courses, :phase, index: true
    add_foreign_key :courses, :phases
  end
end
