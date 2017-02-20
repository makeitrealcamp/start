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

require 'rails_helper'

RSpec.describe Billing::Charge, type: :model do
  context "before_save" do
    it "creates user if charge is paid" do
      path = create(:path)
      ENV['REACT_REDUX_PATH_ID'] = path.id.to_s

      expect {
        Billing::Charge.create!(first_name: "Test", last_name: "Charge",
            email: "test.charge@example.com", description: "Curso de React",
            currency: "COP", amount: 299000, tax_percentage: 0.19, tax: 47739.5,
            status: :paid, customer_name: "Test Charge",
            customer_email: "test.charge@example.com", customer_id_type: "CC",
            customer_id: "1234567", customer_country: "CO",
            customer_mobile: "1", customer_address: "123")
      }.to change(User, :count).by(1)

      user = User.where(email: "test.charge@example.com").take
      expect(user).to_not be_nil

      expect(user.paths).to include(path)
    end

    it "doesn't create the user if charge is paid" do
      expect {
        Billing::Charge.create!(first_name: "Test", last_name: "Charge",
            email: "test.charge@example.com", description: "Curso de React",
            currency: "COP", amount: 299000, tax_percentage: 0.19, tax: 47739.5,
            status: :rejected, customer_name: "Test Charge",
            customer_email: "test.charge@example.com", customer_id_type: "CC",
            customer_id: "1234567", customer_country: "CO",
            customer_mobile: "1", customer_address: "123")
      }.to_not change(User, :count)
    end
  end
end
