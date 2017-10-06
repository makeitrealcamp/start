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
    coupon: :string,
    epayco_ref: :string,
    epayco_approval_code: :string,
    epayco_transaction_date: :string,
    epayco_franchise: :string,
    epayco_card_number: :string,
    epayco_bank_name: :string

  enum payment_method: [:credit_card, :pse, :deposit]
  enum status: [:created, :pending, :paid, :rejected, :error]

  before_create :generate_uid
  after_initialize :default_values
  before_save :handle_before_save
  after_save :handle_after_save

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

    def handle_before_save
      provision_user if status_was != status && self.paid?
    end

    def handle_after_save
      if status_was != status && self.paid?
        self.user.send_course_welcome_email(self)
        ConvertLoop.people.create_or_update(email: self.email, add_to_segments: ["React Redux"])
      elsif status_was != status && self.rejected?
        SubscriptionsMailer.charge_rejected(self).deliver_later
      end
    end

    def provision_user
      self.user = User.where(email: self.email).take
      unless self.user
        self.user = User.create!(email: self.email,
                            first_name: self.first_name,
                            last_name: self.last_name,
                            status: :created,
                            account_type: :paid_account,
                            access_type: :password)
      end
      path = Path.find(ENV['REACT_REDUX_PATH_ID'])
      self.user.paths << path
    end
end
