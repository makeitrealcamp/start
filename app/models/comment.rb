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

class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  belongs_to :response_to, class_name: "Comment"

  validates :commentable, presence: true
  validates :user, presence: true
  validates :text, presence: true

  def as_json(options)
    json = super(options.merge(
      include: [{user: { methods: [:first_name, :avatar_url], only: [] }}]
    ))
  end

end
