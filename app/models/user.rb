# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(100)
#  roles           :string           is an Array
#  password_digest :string
#  first_name      :string(50)
#  last_name       :string(50)
#  birthday        :date
#  phone           :string(15)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  last_active_at  :datetime
#

class User < ActiveRecord::Base
  has_secure_password validations: false

  has_many :solutions, dependent: :destroy
  has_and_belongs_to_many :resources

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :password, presence: true, length: { within: 6..40 }, on: :create
  validates :password, presence: true, length: { within: 6..40 }, if: :password_digest_changed?

  after_initialize :default_values

  def has_role?(role)
    roles && roles.include?(role)
  end

  def is_admin?
    has_role?("admin")
  end

  private
    def default_values
      self.roles ||= ["user"]
    end
end
