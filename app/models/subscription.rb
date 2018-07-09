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

class Subscription < ApplicationRecord
  belongs_to :user
  enum status: [:active,:cancelled]

  validates :user, presence: true

  validate :validate_1_active_subscription_per_user


  after_initialize :defaults
  after_save :update_user_account_type

  def cancel
    self.status = :cancelled
    self.save
  end

  protected

  def update_user_account_type
    unless self.user.is_admin?
      case self.status
      when "cancelled"
        self.user.account_type = :free_account
      when "active"
        self.user.account_type = :paid_account
      end
      self.user.save!
    end
  end

  def defaults
    self.status ||= :active
  end

  def validate_1_active_subscription_per_user
    if(self.active? && self.user && self.user.subscriptions.active.any?)
      errors.add(:user,"should not have more than 1 active subscription")
    end
  end

end
