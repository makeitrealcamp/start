class RemovePhaseFromCourse < ActiveRecord::Migration
  def up
    connection = ActiveRecord::Base.connection

    Course.all.each do |c|
      query = connection.execute("select phase_id from courses where id = #{c.id}")
      phase_id = query.first["phase_id"]
      c.phases << Phase.find(phase_id)
    end
    remove_reference :courses, :phase
  end
  def down
    add_reference :courses, :phase
  end

end
