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

FactoryGirl.define do
  factory :lesson_completion do
    user nil
lesson nil
  end

end
