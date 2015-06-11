# == Schema Information
#
# Table name: phases
#
#  id          :integer          not null, primary key
#  number      :integer
#  name        :string
#  description :text
#  slug        :string
#  row         :integer
#  published   :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Phase < ActiveRecord::Base
  has_many :courses
  include RankedModel
  ranks :row

  extend FriendlyId
  friendly_id :name
  
end
