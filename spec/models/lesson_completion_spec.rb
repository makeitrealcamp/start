# == Schema Information
#
# Table name: lesson_completions
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  lesson_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe LessonCompletion, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
