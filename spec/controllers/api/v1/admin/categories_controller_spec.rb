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

    it 'returns only active categories' do
      request.headers.merge!(token)
      FactoryBot.create(:category, is_active: true)
      request.headers.merge!(token)
      FactoryBot.create(:category, name: 'lps', is_active: false)

      get :index, params: {}
      cats = JSON.parse(response.body)
      expect(cats.length).to eq(1)
    end

    it 'returns ordered categories' do
      request.headers.merge!(token)
      FactoryBot.create(:category, name: 'soul')
      request.headers.merge!(token)
      FactoryBot.create(:category, name: 'blues')
      request.headers.merge!(token)
      FactoryBot.create(:category, name: 'rap')

      get :index, params: {}
      cats = JSON.parse(response.body)
      expect(cats[0]['name']).to eq('blues')
      expect(cats[1]['name']).to eq('rap')
      expect(cats[2]['name']).to eq('soul')
    end
  end
end