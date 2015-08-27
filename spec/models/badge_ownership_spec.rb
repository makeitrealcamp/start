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

require 'rails_helper'

RSpec.describe BadgeOwnership, type: :model do
  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:badge) }
  end

  context 'validations' do
    it { should validate_presence_of :user }
    it { should validate_presence_of :badge }
  end
end
