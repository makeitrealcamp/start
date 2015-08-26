# == Schema Information
#
# Table name: phases
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  slug        :string
#  row         :integer
#  published   :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  color       :string
#

require 'rails_helper'

RSpec.describe Phase, type: :model do
  context 'associations' do
    it { should have_many(:courses) }
  end
end
