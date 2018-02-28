# == Schema Information
#
# Table name: applicant_activities
#
#  id           :integer          not null, primary key
#  applicant_id :integer
#  user_id      :integer
#  comment_type :integer
#  comment      :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class ApplicantActivity < ActiveRecord::Base
	belongs_to :user

	enum comment_type:[:cambio_de_estado, :texto, :correo]
end
