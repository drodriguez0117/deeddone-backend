class SigninController < ApplicationController
  before_action :authorize_access_request!, only: [:destroy]

  def create
    user = User.find_by!(email: session_params[:email])
    if user.authenticate(session_params[:password])
      payload = { user_id: user.id }
      session = JWTSessions::Session.new(payload: payload,
                                         refresh_by_access_allowed: true)
      tokens = session.login

      response.set_cookie(JWTSessions.access_cookie,
                          value: tokens[:access],
                          httponly: true,
                          secure: Rails.env.production?)
      render json: { csrf: tokens[:crsf]}
    else
      not_authorized
    end
  end

  # TODO: finish destroy method
  def destroy
    render json: :ok
  end

  private

  def session_params
    params.permit(:email, :password)
  end
end
