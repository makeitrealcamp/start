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

  default_scope { order("created_at DESC") }

  after_create :notify_commenters

  def as_json(options)
    json = super(options.merge(
      include: [{user: { methods: [:first_name, :avatar_url], only: [] }}]
    ))
  end

  def is_response?
    !self.response_to.nil?
  end

  def name_for_notification
    "Comentario de #{commentable.name_for_notification}"
  end

  def url_for_notification
    commentable.url_for_notification
  end

  protected

    def validate_response_to_response
      if self.response_to && self.response_to.is_response?
        errors.add(:response_to,"Response to a response is not allowed")
      end
    end

    def notify_commenters
      commenters = User.commenters_of(self.commentable)
      commenters = commenters.where.not(id: self.user_id) # exclude commenter
      # notifiy user if response
      if is_response?
        commenters = commenters.where.not(id: response_to.user_id)
        unless response_to.user == self.user
          response_to.user.notifications.create!(notification_type: :comment_response,data: {response_id: self.id})
        end
      end
      commenters.each do |commenter|
        commenter.notifications.create!(notification_type: :comment_activity,data: {comment_id: self.id})
      end
    end
end
