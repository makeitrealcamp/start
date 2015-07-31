class ActivateUserForm < BaseForm

  attribute :token, String
  attribute :password, String
  attribute :password_confirmation, String
  attribute :has_public_profile, Boolean
  attribute :gender, String
  attribute :first_name, String
  attribute :birthday, String
  attribute :mobile_number, String
  attribute :nickname, String

  validates :password, presence: true, length: { within: 6..40 }
  validates :password_confirmation, presence: true
  validates :gender, inclusion: {in: ["male","female"]}, if: -> { !self.gender.blank? }
  validates_confirmation_of :password

  validate :token_existence

  def email
    set_user
    @user.email unless @user.nil?
  end

  private

    def persist!
      set_user
      ActiveRecord::Base.transaction do
        attrs = {
          password: self.password,
          password_confirmation: self.password_confirmation,
          has_public_profile: self.has_public_profile,
          gender: self.gender,
          first_name: self.first_name,
          birthday: self.birthday,
          mobile_number: self.mobile_number,
          nickname: self.nickname
        }.delete_if { |k,v| v.nil? || v.blank? }
        
        @user.update!(attrs)
        @user.activate!
      end
    end

    def token_existence
      set_user
      if @user.nil?
        errors[:token] << "no válido" if @user.nil?
      elsif !@user.has_valid_account_activation_token?
        errors[:token] << "vencido. Solicita uno nuevo"
      end
    end

    def set_user
      @user = User.where("settings -> 'password_reset_token' = ?",self.token).take
    end

end
