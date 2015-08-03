class PasswordResetRequestForm < BaseForm

  attribute :email, String

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validate :existence_of_email

  private
    def existence_of_email
      errors[:email] << "no encontrado"  unless User.exists?(email: self.email)
    end
end
