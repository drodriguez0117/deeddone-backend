require 'rails_helper'

RSpec.describe 'Listings', type: :request do
  describe 'GET api/v1/listings' do
    it 'works! (now write some real specs)' do
      get '/api/v1/listings'
      expect(response).to have_http_status(200)
    end
  end

  describe 'get all listings route' do
    let!(:listings) {FactoryBot.create_list(:listing, 20)}

    before {get '/api/v1/listings'}

    it 'returns all listings' do
      expect(JSON.parse(response.body).size).to eq(20)
    end

    it 'returns status 200' do
      expect(response).to have_http_status(:success)
    end
  end
end
