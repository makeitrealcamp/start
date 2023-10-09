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
        messages.append({ role: "assistant", content: chat_message.response })
      end
    end

    text = ""
    response = openai_client.chat(
      parameters: {
        model:  "gpt-3.5-turbo",
        messages: messages,
        temperature:  0.5,
        # stream: proc do |chunk, _bytesize|
        #   str = chunk.dig("choices", 0, "delta", "content")
        #   text += str if str.present?
        #   # Pusher.trigger("chat-message-#{message.id}", "chat-message:chunk", { message_id: message.id, chunk: str })
        # end
      }
    )

    text = response.dig("choices", 0, "message", "content")

    # text = "¡Claro! Aquí tienes un ejemplo básico de un documento HTML:\n\n```html\n<!DOCTYPE html>\n<html>\n<head>\n    <title>Título de la página</title>\n</head>\n<body>\n    <h1>Encabezado de nivel 1</h1>\n    <p>Este es un párrafo de ejemplo.</p>\n    <ul>\n        <li>Elemento de lista 1</li>\n        <li>Elemento de lista 2</li>\n        <li>Elemento de lista 3</li>\n    </ul>\n</body>\n</html>\n```\n\nEste es un documento HTML básico que incluye el esqueleto básico de una página web. <h1>El contenido se encuentra dentro de las etiquetas `<body>`, mientras que el encabezado de la página se encuentra dentro de las etiquetas `<head>`.\n\nmientras que el encabezado de la página se encuentra dentro de las etiquetas `<head>`.\n\n mientras que el encabezado de la página se encuentra dentro de las etiquetas `<head>`."
    p text
    text = ApplicationController.helpers.markdown(text, escape_html: true)
    message.update!(response: text)
    Pusher.trigger("chat-message-#{message.id}", "chat-message:end", { message_id: message.id, text: text })
  rescue => e
    Rails.logger.error "Backtrace: \n\t#{e.backtrace.join("\n\t")}"
    Pusher.trigger("chat-message-#{message_id}", "chat-message:error", { message_id: message_id, error: e.message })
  end
end
