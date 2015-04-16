# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(100)
#  roles           :string           is an Array
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  last_active_at  :datetime
#  profile         :hstore
#  status          :integer
#  settings        :hstore
#  account_type    :integer
#

require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user){ create(:user) }
  subject { User.new }

  context 'associations' do
    it { should have_many(:solutions).dependent(:destroy) }
    it { should  have_and_belong_to_many(:resources)}
  end

  context 'validations ' do
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should should_not allow_value("email.example").for(:email) }
    it { should have_secure_password }
    it { should validate_length_of(:password).is_at_least(6).is_at_most(40) }
  end

  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  describe '#type_student' do
    it 'return true when type is free' do
      expect(build(:user).free_account?).to be true
    end
  end
end
