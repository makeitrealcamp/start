# == Schema Information
#
# Table name: resources_users
#
#  user_id     :integer          not null
#  resource_id :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe ResourceCompletion, type: :model do

  context 'associations' do
    it { should belong_to(:user)  }
    it { should belong_to(:resource) }
  end
end
