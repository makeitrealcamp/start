class TextGenerationJob < ApplicationJob
  queue_as :default

  def perform(message_id)
    openai_client = OpenAI::Client.new

    message = ChatMessage.find(message_id)
    chat = message.chat
    chat_messages = chat.chat_messages

    messages = [{ role: "system", content: chat.instructions }]
    chat_messages.each do |chat_message|
      messages.append({ role: "user", content: chat_message.request })
      if chat_message.id == message_id
        break
      else
        messages.append({ role: "assistant", content: chat_message.response }) if chat_message.response.present?
      end
    end

    text = ""
    response = openai_client.chat(
      parameters: {
        model:  "gpt-3.5-turbo",
        messages: messages,
        temperature:  0.5
      }
    )

    text = response.dig("choices", 0, "message", "content")
    text = ApplicationController.helpers.markdown(text, escape_html: true)
    message.update!(response: text)
    Pusher.trigger("chat-message-#{message.id}", "chat-message:end", { message_id: message.id, text: text })
  rescue => e
    Rails.logger.error "Backtrace: \n\t#{e.backtrace.join("\n\t")}"
    Pusher.trigger("chat-message-#{message_id}", "chat-message:error", { message_id: message_id, error: e.message })
  end
end
