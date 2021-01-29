class LoginController < ApplicationController
  skip_before_action :authorized

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      payload = { user_id: user.id }
      token = encode_token(payload)

      render json: { token: token, id: user.id, email: user.email }
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  def session_params
    params.permit(:email, :password)
  end
end
