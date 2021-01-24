# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegisterController, type: :controller do
  describe '#create' do
    let(:user_params) do
      { email: 'test@domain.com',
        password: 'password',
        password_confirmation: 'password' }
    end

    it 'returns http success' do
      post :create, params: user_params
      expect(response).to be_successful
      expect(response.cookies[JWTSessions.access_cookie]).to be_present
    end

    it 'returns user parameters' do
      post :create, params: user_params
      expect(response_json.keys).to eq %w[csrf id email]
    end

    it 'increases count' do
      expect do
        post :create, params: user_params
      end.to change(User, :count).by(1)
    end
    
    # factorybot create
    # post
    #
  end
end
