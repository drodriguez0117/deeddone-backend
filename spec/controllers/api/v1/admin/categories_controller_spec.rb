require 'rails_helper'
require 'support/active_storage_helpers'

RSpec.describe Api::V1::Admin::CategoriesController, type: :controller do
  let(:category) { FactoryBot.create(:category) }
  let(:user) { FactoryBot.create(:user) }

  let(:category) do
    FactoryBot.create(:category, user: user)
  end

  let(:auth_token) do
    payload = { user_id: user.id }
    secret = Rails.application.credentials.secret_jwt_encryption_key
    JWT.encode(payload, secret, 'HS256')
  end

  let(:token) do
    { 'Authorization' => "Bearer #{auth_token}" }
  end

  describe '#index' do
    it 'returns a success response' do
      request.headers.merge!(token)
      get :index, params: {}
      expect(response).to have_http_status(:success)
    end
  end
end