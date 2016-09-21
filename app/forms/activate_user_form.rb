class ActivateUserForm < BaseForm

  def self.delegate_to_user
    lambda { |form,attribute| form.user.send(attribute.name) }
  end

  attribute :first_name, String, default: delegate_to_user
  attribute :password, String, default: delegate_to_user
  attribute :birthday, String, default: delegate_to_user
  attribute :mobile_number, String, default: delegate_to_user
  attribute :nickname, String, default: delegate_to_user
  attribute :user, User

  validates :nickname, presence: true
  validates :password, presence: true, if: -> { user.password? && !user.password_digest }
  validates :user, presence: true
  validates :nickname, format: { with: /\A[a-zA-Z0-9_\-]+\Z/ }

  validate :nickname_uniqueness


  def email
    self.user.email unless self.user.nil?
  end

  private
    def persist!
      ActiveRecord::Base.transaction do
        attrs = {
          first_name: self.first_name,
          birthday: self.birthday,
          mobile_number: self.mobile_number,
          nickname: self.nickname
        }
        attrs[:password] = self.password if self.user.password? && self.password

        self.user.update!(attrs)
        self.user.activate!
      end
    end

    def nickname_uniqueness
      unless self.user.nil?
        errors[:nickname] << "ya ha sido tomado por otro usuario" if User.exists?(['nickname = ? and id <> ?', self.nickname, self.user.id])
      end
    end
end
