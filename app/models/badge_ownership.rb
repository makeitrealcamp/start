# == Schema Information
#
# Table name: badge_ownerships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  badge_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BadgeOwnership < ActiveRecord::Base
  belongs_to :user
  belongs_to :badge

  validates :user, presence: true
  validates :badge, presence: true
end
