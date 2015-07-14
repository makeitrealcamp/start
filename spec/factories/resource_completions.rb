FactoryGirl.define do
  factory :resource_completion do
    association  :user, factory: :user
    association  :resource, factory: :resource
  end
end
