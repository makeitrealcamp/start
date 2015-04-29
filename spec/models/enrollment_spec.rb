# == Schema Information
#
# Table name: enrollments
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  resource_id   :integer
#  price         :decimal(, )
#  valid_through :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Enrollment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
