# == Schema Information
#
# Table name: chats
#
#  id           :bigint           not null, primary key
#  user_id      :bigint           not null
#  challenge_id :bigint           not null
#  instructions :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_chats_on_challenge_id  (challenge_id)
#  index_chats_on_user_id       (user_id)
#
class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :challenge, optional: true

  has_many :chat_messages, -> { order(created_at: :asc) }
end
