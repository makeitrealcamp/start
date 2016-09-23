class PasswordChangeForm < BaseForm
  attribute :user, User
  attribute :password, String
  attribute :password_confirmation, String

  validates :user, presence: true
  validates :password, presence: true, length: { within: 6..40 }
  validates :password_confirmation, presence: true
  validates_confirmation_of :password

  private
    def persist!
      self.user.update!(password: self.password, password_confirmation: self.password_confirmation)
    end
end
