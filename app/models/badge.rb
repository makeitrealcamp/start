# == Schema Information
#
# Table name: badges
#
#  id             :integer          not null, primary key
#  name           :string
#  description    :text
#  require_points :integer
#  image_url      :string
#  course_id      :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Badge < ActiveRecord::Base
  belongs_to :course
  has_many :badges_users, dependent: :destroy

  validates :name, presence: true
  validates :image_url, presence:  true
  validates :require_points, presence: true
  validates :course, presence: true
end
