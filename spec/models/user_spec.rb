# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(100)
#  roles           :string           is an Array
#  password_digest :string
#  first_name      :string(50)
#  last_name       :string(50)
#  birthday        :date
#  phone           :string(15)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user){create(:user)}
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
end
