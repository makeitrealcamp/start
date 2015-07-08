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
  let!(:course) { create(:course) }
  subject { User.new }

  context 'associations' do
    it { should have_many(:solutions).dependent(:destroy) }
    it { should have_many(:resource_completions) }
    it { should have_many(:auth_providers).dependent(:destroy) }
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
      expect(user.free_account?).to be true
    end
  end

  describe '#completed_challenges' do
    it 'without challenges completed' do
      create(:challenge, course: course, published: false, restricted: true)
      create(:challenge, course: course, published: true, restricted: true)
      expect(user.completed_challenges(course).count).to eq 0
    end

    it 'return only the challenges completed and published'  do

      challenge = create(:challenge, course: course, published: true, restricted: true)
      challenge1 = create(:challenge, course: course, published: false, restricted: true)
      challenge2 = create(:challenge, course: course, published: true, restricted: true)
      #when the challenge s published does count as completed
      create(:solution, user: user, challenge: challenge, status: :completed)
      #when el challenge is unpublished does not count as completed
      create(:solution, user: user, challenge: challenge1, status: :completed)
      #when el challenge is published and the solution have status different to completed
      #does not count as completed
      create(:solution, user: user, challenge: challenge2, status: :created)
      expect(user.completed_challenges(course).count).to eq 1
    end
  end

  describe '#completed_resources' do
    it 'without resources completed' do
      resource  = create(:resource, course: course, published: true)
      resource1 = create(:resource, course: course, published: false)
      resource2 = create(:resource, course: course, published: true)
      expect(user.completed_resources(course).count).to eq 0
    end

    it 'return only the resources completed and published' do
      resource  = create(:resource, course: course, published: true)
      resource1 = create(:resource, course: course, published: false)
      resource2 = create(:resource, course: course, published: true)

      create(:resource_completion, user: user, resource: resource)
      create(:resource_completion, user: user, resource: resource1)
      create(:resource_completion, user: user, resource: resource2)
      expect(user.completed_resources(course).count).to eq 2
    end
  end

  describe '#progress' do
    it 'return 1.0 when the total is 0' do
      expect(user.progress(course)).to eq 1.0
    end

    it 'return percentage ' do
      challenge = create(:challenge, course: course, published: true, restricted: true)
      challenge1 = create(:challenge, course: course, published: false, restricted: true)
      create(:solution, user: user, challenge: challenge, status: :completed)

      resource  = create(:resource, course: course, published: true)
      resource1 = create(:resource, course: course, published: false)
      resource2 = create(:resource, course: course, published: true)

      create(:resource_completion, user: user, resource: resource)
      create(:resource_completion, user: user, resource: resource1)
      expect(user.progress(course)).to be < 1.0
    end
  end
end
