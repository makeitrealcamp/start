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

FactoryGirl.define do
  factory :billing_coupon, :class => 'Billing::Coupon' do
    name "MyString"
discount "9.99"
  end

end
