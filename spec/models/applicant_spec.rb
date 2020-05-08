# == Schema Information
#
# Table name: applicants
#
#  id         :integer          not null, primary key
#  type       :string(30)
#  email      :string
#  first_name :string
#  last_name  :string
#  country    :string(3)
#  mobile     :string(20)
#  status     :integer          default("0")
#  info       :hstore
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Applicant, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
