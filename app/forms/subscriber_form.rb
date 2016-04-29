class SubscriberForm < BaseForm
  attribute :first_name, String
  attribute :last_name, String
  attribute :email, String
  attribute :goal, String

  validates :first_name, :last_name, :email, :goal, presence: true
end
