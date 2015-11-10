# == Schema Information
#
# Table name: paths
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  published   :boolean          default(FALSE)
#

class Path < ActiveRecord::Base
  validates :name, presence: true
  validates :description, presence: true

  has_many :phases

  def courses
    Course.joins(:course_phases).joins(:phases)
      .where("course_phases.phase_id" => phases.pluck(:id) ).uniq
  end

  def challenges
    Challenge.where(course_id: courses.pluck(:id))
  end

  def first_challenge
    challenges.published.path_order.first
  end

end
