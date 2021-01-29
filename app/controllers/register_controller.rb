# frozen_string_literal: true

class RegisterController < ApplicationController
  before_action :authorized, only: []

  def create
    #logger = Logger.new(STDOUT)

    @user = User.new(user_params)
    if @user.save
      payload = { user_id: @user.id }
      #session = JWTSessions::Session.new(payload: payload,
      #                                   refresh_by_access_allowed: true)
      #token = session.login
      token = encode_token(payload)

      #logger.debug "token: #{token}"
      # response.set_cookie(create_access_token(payload),
      #                     #value: token[:access],
      #                     httponly: true,
      #                     secure: Rails.env.production?)
      render json: { token: token, id: @user.id, email: @user.email }
    else
      render json: { error: @user.errors.full_messages.join(' '),
                     status: :unprocessable_entity }
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end
