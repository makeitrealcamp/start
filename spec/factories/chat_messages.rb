# == Schema Information
#
# Table name: chat_messages
#
#  id         :bigint           not null, primary key
#  chat_id    :bigint           not null
#  request    :text
#  response   :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_chat_messages_on_chat_id  (chat_id)
#
FactoryGirl.define do
  factory :chat_message do
    chat nil
request "MyText"
response "MyText"
  end

end
