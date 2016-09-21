class PasswordResetForm < BaseForm

  attribute :token, String
  attribute :password, String
  attribute :password_confirmation, String

  validates :token, presence: true
  validates :password, presence: true, length: { within: 6..40 }
  validates :password_confirmation, presence: true
  validates_confirmation_of :password

  validate :token_existence

private

  def persist!
    set_user
    @user.update!(password: self.password, password_confirmation: self.password_confirmation)
  end


  def token_existence
    set_user
    if @user.nil?
      errors[:token] << "no válido" if @user.nil?
    elsif !@user.has_valid_password_reset_token?
      errors[:token] << "vencido. Solicita uno nuevo"
    end
  end

  def set_user
    @user = User.where("settings -> 'password_reset_token' = ?",token).take
  end
end
