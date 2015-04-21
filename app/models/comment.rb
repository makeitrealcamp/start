# == Schema Information
#
# Table name: comments
#
#  id             :integer          not null, primary key
#  discussion_id  :integer
#  text           :text
#  response_to_id :integer
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Comment < ActiveRecord::Base
  belongs_to :discussion
  belongs_to :user
  belongs_to :response_to, class_name: "Comment"

  validates :discussion, presence: true
  validates :user, presence: true
  validates :text, presence: true  

end
