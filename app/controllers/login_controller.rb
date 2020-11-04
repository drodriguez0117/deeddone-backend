class LoginController < ApplicationController
  before_action :authorize_access_request!, only: [:destroy]

  def create
    user = User.find_by!(email: session_params[:email])
    if user.authenticate(session_params[:password])
      payload = { user_id: user.id }
      session = JWTSessions::Session.new(payload: payload,
                                         refresh_by_access_allowed: true,
                                         namespace: "user_#{user.id}")
      tokens = session.login
      logger.debug "tokens_access: #{user.email}"

      response.set_cookie(JWTSessions.access_cookie,
                          value: tokens[:access],
                          httponly: true,
                          secure: Rails.env.production?)
      logger.debug "after response: #{tokens[:csrf]}"
      render json: { csrf: tokens[:csrf], id: user.id, email: user.email }
    else
      not_authorized
    end
  end

  def destroy
    session = JWTSessions::Session.new(payload: payload,
                                       namespace: "user_#{payload['user_id']}")
    session.flush_by_access_payload
    logger.debug "in destroy"
    render json: :ok
  end

  private

  def session_params
    params.permit(:email, :password)
  end
end
