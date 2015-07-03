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

class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  belongs_to :response_to, class_name: "Comment"
  has_many :responses, class_name: 'Comment', foreign_key: 'response_to_id', dependent: :delete_all

  validates :commentable, presence: true
  validates :user, presence: true
  validates :text, presence: true

  validate :validate_response_to_response

  def as_json(options)
    json = super(options.merge(
      include: [{user: { methods: [:first_name, :avatar_url], only: [] }}]
    ))
  end

  def is_response?
    !self.response_to.nil?
  end

  protected

  def validate_response_to_response
    if self.response_to && self.response_to.is_response?
      errors.add(:response_to,"Response to a response is not allowed")
    end
  end
end
