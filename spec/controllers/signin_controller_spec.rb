require 'rails_helper'

RSpec.describe SigninController, type: :controller do
  let(:user) { create(:user) }
  describe 'POST #create' do
    let(:password) { 'password' }
    let(:user_params) { { email: user.email, password: password } }

    it 'returns http success' do
      get :create, params: user_params
      expect(response).to be_successful
      expect(response_json.keys).to eq ['csrf']
      expect(response.cookies[JWTSessions.access_cookie]).to be_present
    end

    it 'returns unauthorized for invalid params' do
      post :create, params: { email: user.email, password: 'not_right' }
      expect(response).to have_http_status(401)
    end
  end

end
