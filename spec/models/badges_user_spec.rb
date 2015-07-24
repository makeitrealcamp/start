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

require 'rails_helper'

RSpec.describe BadgesUser, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
