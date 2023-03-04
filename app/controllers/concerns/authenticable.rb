module Authenticable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate, if: -> { request.path.start_with?('/api') }
    protect_from_forgery with: :exception
    skip_before_action :verify_authenticity_token, if: -> { request.path.start_with?('/api') }
  end

  private

  def authenticate
    token = request.headers['Authorization'].split(' ').last
    decoded_token = JWT.decode(token, ENV['JWT_SECRET_KEY'], true, { algorithm: 'HS256' })
  rescue JWT::VerificationError, JWT::DecodeError
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end