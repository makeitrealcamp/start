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
require 'rails_helper'

RSpec.describe Chat, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
