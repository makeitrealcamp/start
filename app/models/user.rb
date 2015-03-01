class User < ActiveRecord::Base
  has_secure_password validations: false

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :password, presence: true, length: { within: 6..40 }, if: :password_digest_changed?

  after_initialize :default_values

  private
    def default_values
      self.roles ||= ["user"]
    end
end
