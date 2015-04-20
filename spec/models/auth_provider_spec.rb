# == Schema Information
#
# Table name: auth_providers
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  provider   :string
#  uid        :string
#  image      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe AuthProvider, type: :model do
  context 'associations' do
    it { should belong_to(:user) }
  end

  context 'validations' do
    it { should validate_presence_of :uid }
    it { should validate_presence_of :provider }
    it { should validate_presence_of :user }
  end
end
