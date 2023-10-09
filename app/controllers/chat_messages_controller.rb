class ChatMessagesController < ApplicationController
  before_action :private_access

  def create
    chat = Chat.find(params[:chat_id])
    message = chat.chat_messages.create!(message_params)

    TextGenerationJob.perform_later(message.id)

    render json: message
  end

  def update
    message = ChatMessage.find(params[:id])
    message.update(message_params)

    render json: message
  end

  private
    def message_params
      params.require(:chat_message).permit(:request, :response)
    end
end