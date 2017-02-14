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

class Billing::Charge < ActiveRecord::Base
  belongs_to :user

  hstore_accessor :details,
    first_name: :string,
    last_name: :string,
    email: :string,
    customer_name: :string,
    customer_email: :string,
    customer_id_type: :string,
    customer_id: :string,
    customer_country: :string,
    customer_mobile: :string,
    customer_address: :string,
    card_token: :string,
    error_message: :string,
    stack_trace: :string,
    attempts: :integer,
    epayco_customer_id: :string,
    ip: :string,
    epayco_ref: :string

  enum payment_method: [:credit_card, :pse, :deposit]
  enum status: [:created, :pending, :paid, :rejected, :error]

  before_create :generate_uid
  before_create :default_values

  private
    def generate_uid
      begin
        self.uid = SecureRandom.hex(5)
      end while self.class.exists?(uid: self.uid)
    end

    def default_values
      self.attempts ||= 0;
    end
end
