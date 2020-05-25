require 'rails_helper'

RSpec.describe SignupController, type: :controller do

  describe 'POST #create' do
    let(:user_params) {
      { email: 'test@domain.com', password: 'password', password_confirmation: 'password'}
    }

    it 'returns http succes' do
      post :create, params: user_params
      expect(response).to be_successful
      expect(response_json.keys).to eq ['csrf']
      expect(response.cookies[JWTSessions.access_cookie]).to be_present
    end

    it 'creates a new user' do
      expect {
        post :create, params: user_params
      }.to change(User, :count).by(1)
    end
  end

end
