FactoryGirl.define do
  factory :path_subscription do
    user { create(:user) }
    path { create(:path) }
  end

end
