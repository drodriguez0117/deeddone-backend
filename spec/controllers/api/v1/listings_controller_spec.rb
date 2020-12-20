require 'rails_helper'
require 'support/active_storage_helpers'

RSpec.describe Api::V1::ListingsController, type: :controller do
  let!(:user) { FactoryBot.create(:user)}
  let!(:category) { FactoryBot.create(:category)}
  let!(:listing) { FactoryBot.create(:listing, category: category, user: user) }

  describe '#index' do
    it 'returns a success response' do
      get :index, params: {}
      expect(response).to be_successful
    end
  end

  describe '#show' do
    it 'returns a success response' do
      get :show, params: { id: listing.id }
      expect(response).to have_http_status(:ok)
      expect(response).to be_successful
    end
  end
end
