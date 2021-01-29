# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authorized

  def jwt_key
    Rails.application.credentials.secret_jwt_encryption_key
  end

  def encode_token(payload)
    JWT.encode(payload, jwt_key)
  end

  def auth_header
    # { Authorization: 'Bearer <token>' }
    request.headers['Authorization']
  end

  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1]
      # header: { 'Authorization': 'Bearer <token>' }
      begin
        JWT.decode(token, jwt_key, true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def logged_in_user
    if decoded_token
      user_id = decoded_token[0]['user_id']
      @user = User.find_by(id: user_id)
    end
  end

  def logged_in?
    !!logged_in_user
  end

  def authorized
    render json: { message: 'What is wrong with you, Melvin?!' }, status: :unauthorized unless logged_in?
  end
end
