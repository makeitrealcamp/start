# == Schema Information
#
# Table name: lessons
#
#  id          :integer          not null, primary key
#  section_id  :integer
#  name        :string
#  video_url   :string
#  description :text
#  row         :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Lesson, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
