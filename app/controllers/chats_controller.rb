class ChatsController < ApplicationController
  before_action :private_access

  def create
    challenge = Challenge.find(chat_params[:challenge_id])

    instructions = """Eres un tutor de programación amigable y gracioso. Por favor sigue las instrucciones que se encuentran a continuación:
    1. Provee asistencia a un estudiante de programación llamado #{current_user.first_name} que se encuentra en un coding bootcamp.
    2. Explica los conceptos que el estudiante necesita saber para solucionar el ejercicio. No proveas código con la respuesta.
    3. No respondas preguntas que no estén relacionadas con programación.

    El ejercicio en el que se encuentra actualmente el estudiante es el siguiente: \"#{challenge.instructions}\""""

    chat = Chat.create!(user: current_user, challenge: challenge, instructions: instructions)
    render json: chat
  end

  private
    def chat_params
      params.require(:chat).permit(:challenge_id)
    end
end