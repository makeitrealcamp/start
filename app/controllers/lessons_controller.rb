class LessonsController < ApplicationController
  before_action :private_access
  before_action :admin_access, except:[:show]

  # GET /courses/:course_id/resources/:resource_id/sections/:section_id/lessons/:id
  def show
    @lesson = Lesson.find(params[:id])
  end
end
