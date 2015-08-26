# == Schema Information
#
# Table name: levels
#
#  id              :integer          not null, primary key
#  name            :string
#  required_points :integer
#  image_url       :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe Level, type: :model do
  context 'associations' do
    it { should have_many(:users) }
  end

  context 'validations' do
    it { should validate_presence_of :name }
  end
end
