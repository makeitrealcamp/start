# == Schema Information
#
# Table name: billing_coupons
#
#  id         :integer          not null, primary key
#  name       :string(30)
#  discount   :decimal(, )
#  expires_at :datetime         not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Billing::Coupon < ActiveRecord::Base

  def is_valid?
    self.expires_at > DateTime.current
  end
end
