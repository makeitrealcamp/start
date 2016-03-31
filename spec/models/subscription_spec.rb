# == Schema Information
#
# Table name: subscriptions
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  status              :integer
#  cancellation_reason :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_subscriptions_on_user_id  (user_id)
#

require "rails_helper"

RSpec.describe Subscription, type: :model do

  let(:user_free) { create(:user,account_type: :free_account) }
  let(:user_paid) { create(:user,account_type: :paid_account) }
  let(:admin) { create(:user,account_type: :admin_account) }
  let(:subscription) { build(:subscription) }

  context "validations" do
    it { should validate_presence_of :user }
    it { should belong_to :user }
    it "doesn't allow more than 1 active subscription per user" do
      subscription.save
      invalid_subscription = subscription.user.subscriptions.build
      expect(invalid_subscription).to_not be_valid
      expect(invalid_subscription.errors).to have_key(:user)
    end
  end

  context "factory" do
    it "has a valid factory" do
      expect(build(:subscription)).to be_valid
    end
  end

  context "after update" do
    it "changes the user to paid_account when created" do
      subscription.user = user_free
      subscription.save

      expect(user_free.reload.account_type).to eq("paid_account")
    end

    it "changes the user to free_account when cancelled" do
      subscription.user = user_paid
      subscription.save
      subscription.cancel

      expect(user_paid.reload.account_type).to eq("free_account")
    end

    it "doesn't modify the account type of an admin after cancellation" do
      subscription.user = admin
      subscription.save
      expect(admin.reload.account_type).to eq("admin_account")

      subscription.cancel

      expect(admin.reload.account_type).to eq("admin_account")
    end
  end
end
