# == Schema Information
#
# Table name: enrollments
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  resource_id   :integer
#  price         :decimal(, )
#  valid_through :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Enrollment < ActiveRecord::Base
  belongs_to :user
  belongs_to :resource

  validates :user, presence: true
  validates :resource, presence: true

  after_initialize :defaults

  scope :active, ->{ where("valid_through >= ?",DateTime.now)}

  def self.calc_valid_through(user,resource)
    #TODO: Do the actual calculation based on the type of subscription of the user
    DateTime.now + 1.year
  end

  protected
  def defaults
    self.valid_through ||= DateTime.now + 1.year
  end

end
