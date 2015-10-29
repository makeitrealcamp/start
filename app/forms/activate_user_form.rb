class ActivateUserForm < BaseForm

  def self.delegate_to_user
    lambda { |form,attribute| form.user.send(attribute.name) }
  end

  attribute :token, String
  attribute :password, String
  attribute :password_confirmation, String
  attribute :has_public_profile, Boolean, default: delegate_to_user
  attribute :gender, String, default: delegate_to_user
  attribute :first_name, String, default: delegate_to_user
  attribute :birthday, String, default: delegate_to_user
  attribute :mobile_number, String, default: delegate_to_user
  attribute :nickname, String, default: delegate_to_user

  validates :gender, inclusion: {in: ["male","female"]}, if: -> { !self.gender.blank? }
  validates_confirmation_of :password
  validates :nickname, presence: true

  validate :token_existence
  validate :nickname_uniqueness


  def email
    self.user.email unless self.user.nil?
  end

  def user
    @user ||= User.where("settings -> 'password_reset_token' = ?",self.token).take
  end

  private

    def persist!
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
        }

        self.user.update!(attrs)
        self.user.activate!
      end
    end

    def token_existence
      if self.user.nil?
        errors[:token] << "no válido" if self.user.nil?
      elsif !self.user.has_valid_account_activation_token?
        errors[:token] << "vencido. Solicita uno nuevo"
      end
    end

    def nickname_uniqueness
      unless self.user.nil?
        errors[:nickname] << "ya ha sido tomado por otro usuario" if User.exists?(nickname: self.nickname)
      end
    end

    def user_data
      byebug
    end

end
