# == Schema Information
#
# Table name: applicant_activities
#
#  id           :integer          not null, primary key
#  applicant_id :integer
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  info         :hstore
#  type         :string
#

require 'rails_helper'

RSpec.describe ChangeStatusApplicantActivity, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
