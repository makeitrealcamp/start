# == Schema Information
#
# Table name: paths
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  published   :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe Path, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
