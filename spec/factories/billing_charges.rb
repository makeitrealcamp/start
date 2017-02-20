# == Schema Information
#
# Table name: billing_charges
#
#  id             :integer          not null, primary key
#  uid            :string(50)
#  user_id        :integer
#  payment_method :integer          default(0)
#  status         :integer          default(0)
#  currency       :string(5)
#  amount         :decimal(, )
#  tax            :decimal(, )
#  tax_percentage :decimal(, )
#  description    :string
#  details        :hstore
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_billing_charges_on_user_id  (user_id)
#

FactoryGirl.define do
  factory :charge, class: 'Billing::Charge' do
    uid "1234"
    amount "100"
    tax "10"
    tax_percentage "0.10"
    description Faker::Lorem.sentence
    details do
      {
        "first_name" => Faker::Name.first_name,
        "last_name" => Faker::Name.last_name,
        "email" => "test.charge@example.com",
        "customer_name" => Faker::Name.name,
      }
    end

    trait :created_deposit do
      payment_method :deposit
      status :created
    end

    trait :created_credit_card do
      payment_method :credit_card
      status :created
    end

    trait :paid_deposit do
      payment_method :deposit
      status :paid
    end

    trait :paid_credit_card do
      payment_method :credit_card
      status :paid
    end

    trait :rejected_credit_card do
      payment_method :credit_card
      status :rejected
      error_message "Declined, sorry"
    end

    trait :created_credit_card do
      payment_method :credit_card
      status :created
    end
  end

end
