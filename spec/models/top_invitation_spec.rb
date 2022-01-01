# == Schema Information
#
# Table name: top_invitations
#
#  id         :bigint           not null, primary key
#  email      :string
#  token      :string(10)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe TopInvitation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
