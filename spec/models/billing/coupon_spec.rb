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

require 'rails_helper'

RSpec.describe Billing::Coupon, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
