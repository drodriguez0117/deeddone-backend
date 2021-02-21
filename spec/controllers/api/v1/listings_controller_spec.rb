# frozen_string_literal: true

require 'rails_helper'
require 'support/active_storage_helpers'

RSpec.describe Api::V1::ListingsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:category) { FactoryBot.create(:category) }
  let(:exchange) { FactoryBot.create(:exchange)}
  let(:listing) { FactoryBot.create(:listing, category: category, exchange: exchange, user: user) }

  # before(:each) do
  #  FactoryBot.create_list(:listing, 4, user: user, category: category)
  # end

  describe '#index' do
    it 'returns a success response' do
      get :index, params: {}
      expect(response).to have_http_status(:success)
    end

    it 'returns a collection of listings' do
      FactoryBot.create_list(:listing, 5, user: user, category: category, exchange: exchange)
      get :index, params: {}
      expect(JSON.parse(response.body).count).to eq 5
    end

    it 'returns listing that have not expired after 30 days' do
      FactoryBot.create(:listing, user: user, category: category, exchange: exchange)
      FactoryBot.create(:listing, user: user, category: category, exchange: exchange, expires_at: (Date.today + 31.days).to_s)
      get :index, params: {}

      actual = JSON.parse(response.body)
      expect(actual.length).to eq 1
    end

    it 'returns listing that expire today' do
      FactoryBot.create(:listing, user: user, category: category, exchange: exchange)
      FactoryBot.create(:listing, user: user, category: category, exchange: exchange, expires_at: (Date.today + 30.days).to_s)
      get :index, params: {}

      actual = JSON.parse(response.body)
      expect(actual.length).to eq 2
    end

    it 'returns listing that are active' do
      FactoryBot.create(:listing, user: user, category: category, exchange: exchange)
      FactoryBot.create(:listing, user: user, category: category, exchange: exchange, is_active: false)
      get :index, params: {}

      actual = JSON.parse(response.body)
      expect(actual.length).to eq 1
    end

    it 'returns listings with an image' do
      file = fixture_file_upload('spec/fixtures/files/melvin.jpg', 'image/jpg')
      FactoryBot.create(:listing, user: user, category: category, exchange: exchange, images: [file])
      get :index, params: {}

      actual = JSON.parse(response.body)
      expect(actual[0]['images'].count).to eq 1
    end

    it 'returns a listing with multiple images' do
      file = fixture_file_upload('spec/fixtures/files/melvin.jpg', 'image/jpg')
      FactoryBot.create(:listing,
                        user: user,
                        category: category,
                        exchange: exchange,
                        images: [file, file])

      get :index, params: {}

      actual = JSON.parse(response.body)
      expect(actual[0]['images']).to be_a Array
      expect(actual[0]['images'].count).to eq 2
    end

    it 'returns listings with a category' do
      FactoryBot.create(:listing, user: user, category: category, exchange: exchange)
      get :index, params: {}

      content = JSON.parse(response.body, symbolize_names: true)
      expect(content[0][:category]).to_not be_nil
    end

    it 'returns listings with a user_id' do
      FactoryBot.create(:listing, user: user, category: category, exchange: exchange)
      get :index, params: {}

      # puts response.status
      # puts response.headers
      # content = JSON.parse(response.body, symbolize_names: true)
      # puts content
      # puts response.body.to_yaml
      # puts content[0][:description]
      # puts "#{response_json[0]['user_id']}"
      # expect(content[0][:user_id]).to_not be_nil
      # instead of using JSON.parse()
      expect(response_json[0]['user_id']).to_not be_nil
    end
  end

  describe '#show' do
    it 'returns a success response' do
      get :show, params: { id: listing.id }
      expect(response).to have_http_status(:ok)
      expect(response).to be_successful
      expect(JSON.parse(response.body).count).to eq(1)
    end

    it 'return a listing with a category' do
      get :show, params: { id: listing.id }
      content = JSON.parse(response.body, symbolize_names: true)
      expect(content[0][:category]).to_not be_nil
    end

    it 'returns a listing with a user_id' do
      get :show, params: { id: listing.id }
      content = JSON.parse(response.body, symbolize_names: true)
      expect(content[0][:user_id]).to_not be_nil
    end
  end
end
