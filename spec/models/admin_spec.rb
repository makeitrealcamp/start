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
require 'rails_helper'

RSpec.describe Admin, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
