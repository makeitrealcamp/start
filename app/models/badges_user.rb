# == Schema Information
#
# Table name: badges_users
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  badge_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BadgesUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :badge
end
