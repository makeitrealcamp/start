# == Schema Information
#
# Table name: paths
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  published   :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe Path, type: :model do
  context "associations" do
    it { should have_many(:phases) }
  end

  context "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
  end

  it "has a valid factory" do
    expect(build(:path)).to be_valid
  end
end
