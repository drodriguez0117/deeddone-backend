# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoginController, type: :controller do
  let(:user) { create(:user) }

  describe '#create' do
    let(:password) { 'password' }
    let(:user_params) { { email: user.email, password: password } }

    it 'returns http success' do
      get :create, params: user_params
      expect(response).to be_successful
      expect(response_json.keys).to eq %w[token id email]
    end

    it 'returns unauthorized for invalid password' do
      post :create, params: { email: user.email, password: 'not_right' }
      expect(response).to have_http_status(401)
      expect(response_json['error']).to eq('Invalid email or password')
    end

    it 'returns unauthorized for invalid email' do
      post :create, params: { email: 'xxx@xxx.com', password: 'not_right' }
      expect(response).to have_http_status(401)
      expect(response_json['error']).to eq('Invalid email or password')
    end
  end
end
