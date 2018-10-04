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

class Billing::Charge < ApplicationRecord
  enum payment_method: [:unknown, :credit_card, :debit_card, :pse, :cash, :referenced, :transfer]
  enum status: [:created, :pending, :paid, :rejected, :error]

  before_create :generate_uid
  after_initialize :default_values
  after_save :handle_after_save

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
    error_message: :string,
    stack_trace: :string,
    attempts: :integer,
    ip: :string

  private
    def generate_uid
      begin
        self.uid = SecureRandom.hex(5)
      end while self.class.exists?(uid: self.uid)
    end

    def default_values
      self.attempts ||= 0
      self.amount ||= 0
      self.tax_percentage ||= 0.19
      self.tax ||= 0
    end

    def handle_after_save
      if status_was != status && self.paid?
        SubscriptionsMailer.course_welcome(self).deliver_later
        begin
          ConvertLoop.people.create_or_update(email: self.email, add_to_segments: ["Express y MongoDB"])
        rescue => e
          Rails.logger.error "Couldn't send user #{self.email} to ConvertLoop: #{e.message}"
        end
      elsif status_was != status && self.rejected?
        SubscriptionsMailer.charge_rejected(self).deliver_later
      end
    end
end
