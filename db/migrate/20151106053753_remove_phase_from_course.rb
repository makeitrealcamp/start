class RemovePhaseFromCourse < ActiveRecord::Migration
  def up
    Course.all.each do |c|
      c.phases << c.phase
    end
    remove_reference :courses, :phase
  end
  def down
    add_reference :courses, :phase
  end

end
