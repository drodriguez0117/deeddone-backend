require 'rails_helper'

RSpec.describe 'Listings', type: :request do
  describe 'GET /listings' do
    it 'returns ok status' do
      get '/listings'
      expect(response).to have_http_status(200)
    end
  end

  describe 'get all listings route' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:listings) { FactoryBot.create_list(:listing, 20, user: user) }

    before {get '/listings'}

    it 'returns all listings' do
      expect(JSON.parse(response.body).size).to eq(20)
    end

    it 'returns status 200' do
      expect(response).to have_http_status(:success)
    end
  end
end
