# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  commentable_id   :integer
#  commentable_type :string
#  text             :text
#  response_to_id   :integer
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_comments_on_commentable_type_and_commentable_id  (commentable_type,commentable_id)
#  index_comments_on_user_id                              (user_id)
#

FactoryGirl.define do
  factory :comment do
    text { Faker::Lorem.paragraph }
    association  :user, factory: :user
    association  :commentable, factory: :challenge
  end
end
