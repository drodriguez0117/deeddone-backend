require 'rails_helper'

RSpec.describe Api::V1::Admin::ExchangesController, type: :controller do
  #let(:exchange) { FactoryBot.create(:exchange) }
  let(:user) { FactoryBot.create(:user) }

  # let(:exchange) do
  #   FactoryBot.create(:exchange, user: user)
  # end

  let(:auth_token) do
    payload = { user_id: user.id }
    secret = Rails.application.credentials.secret_jwt_encryption_key
    JWT.encode(payload, secret, 'HS256')
  end

  let(:token) do
    { 'Authorization' => "Bearer #{auth_token}" }
  end

  describe '#index' do
    # it 'returns a success response' do
    #   request.headers.merge!(token)
    #   get :index, params: {}
    #   expect(response).to have_http_status(:success)
    # end

    it 'returns only active exchanges' do
      request.headers.merge!(token)
      FactoryBot.create(:exchange, name: 'action', is_active: true)
      request.headers.merge!(token)
      FactoryBot.create(:exchange, name: 'lps', is_active: false)

      get :index, params: {}
      cats = JSON.parse(response.body)
      expect(cats.length).to eq(1)
    end

    it 'returns ordered exchanges' do
      request.headers.merge!(token)
      FactoryBot.create(:exchange, name: 'service')
      request.headers.merge!(token)
      FactoryBot.create(:exchange, name: 'plane')
      request.headers.merge!(token)
      FactoryBot.create(:exchange, name: 'hand')

      get :index, params: {}
      cats = JSON.parse(response.body)

      expect(cats[0]['name']).to eq('hand')
      expect(cats[1]['name']).to eq('plane')
      expect(cats[2]['name']).to eq('service')
    end
  end

end
