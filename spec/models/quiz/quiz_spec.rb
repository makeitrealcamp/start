# == Schema Information
#
# Table name: quizzes
#
#  id         :integer          not null, primary key
#  name       :string
#  row        :integer
#  slug       :string
#  course_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_quizzes_on_course_id  (course_id)
#

require 'rails_helper'

RSpec.describe Quiz::Quiz, type: :model do

  it "should have a valid factory" do
    expect(build(:quiz)).to be_valid
  end
end
