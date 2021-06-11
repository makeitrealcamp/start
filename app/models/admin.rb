# == Schema Information
#
# Table name: admins
#
#  id              :bigint           not null, primary key
#  email           :string(100)
#  password_digest :string
#  permissions     :text             default([]), is an Array
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Admin < ApplicationRecord
  has_secure_password validations: false

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :password, presence: true, length: { within: 6..40 }, if: -> { password_digest_changed? }

  def has_role?(role)
    permissions.empty? || permissions.include?(role)
  end
end
