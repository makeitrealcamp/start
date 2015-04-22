# == Schema Information
#
# Table name: discussions
#
#  id           :integer          not null, primary key
#  challenge_id :integer
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Discussion < ActiveRecord::Base
  belongs_to :challenge
  has_many :comments
end
