# == Schema Information
#
# Table name: sections
#
#  id          :integer          not null, primary key
#  resource_id :integer
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  row         :integer
#
# Indexes
#
#  index_sections_on_resource_id  (resource_id)
#

require 'rails_helper'

RSpec.describe Section, type: :model do

  context 'associations' do
    it { should belong_to :resource }
    it { should have_many(:lessons).dependent(:delete_all) }
  end

  context 'validations' do
    it { should validate_presence_of(:title) }
  end
end
