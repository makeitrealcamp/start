# == Schema Information
#
# Table name: enrollments
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  resource_id   :integer
#  price         :decimal(, )
#  valid_through :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do
  factory :enrollment do
    user nil
resource nil
price "9.99"
  end

end
