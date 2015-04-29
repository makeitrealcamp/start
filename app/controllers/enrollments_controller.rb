class EnrollmentsController < ApplicationController
  before_action :private_access

  # POST /courses/:course_id/resources/:resource_id/enrollments
  def create
    resource = Resource.friendly.find(params[:resource_id])
    if current_user.is_enrolled_in?(resource)
      flash[:error] = "Ya estás inscrito en este curso"
      redirect_to course_resource_path(resource.course,resource)

    elsif current_user.has_access_to?(resource)
      enrollment_data = {
        user: current_user,
        resource: resource ,
        valid_through: Enrollment.calc_valid_through(current_user,resource),
        price: current_user.paid_account? ? 0 : resource.price
      }

      Enrollment.create(enrollment_data)

      flash[:notice] = "Gracias por inscribirte, estamos seguros de que vas a disfrutar este curso"
      redirect_to course_resource_path(resource.course,resource)
    end
  end

end
