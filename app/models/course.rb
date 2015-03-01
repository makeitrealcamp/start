# == Schema Information
#
# Table name: courses
#
#  id         :integer          not null, primary key
#  name       :string(20)
#  row        :integer
#  abstract   :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Course < ActiveRecord::Base
  include RankedModel
  ranks :row

  has_many :resources
  has_many :challenges
end
