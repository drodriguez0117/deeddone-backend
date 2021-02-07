require 'rails_helper'

RSpec.describe "Api::V1::Admin::Exchanges", type: :request do
  let(:exchange) { FactoryBot.create(:exchange) }
  let(:user) { FactoryBot.create(:user) }

  let(:exchange) do
    FactoryBot.create(:exchange, user: user)
  end

  let(:auth_token) do
    payload = { user_id: user.id }
    secret = Rails.application.credentials.secret_jwt_encryption_key
    JWT.encode(payload, secret, 'HS256')
  end

  let(:token) do
    { 'Authorization' => "Bearer #{auth_token}" }
  end

  describe 'GET admin/exchanges' do
    it 'returns ok status' do
      admin = FactoryBot.create(:exchange)
      @env = {}
      @env['Authorization'] = "Bearer #{auth_token}"

      get '/admin/exchanges', params: {}, headers: @env
      expect(response).to have_http_status(200)
    end
  end
end
