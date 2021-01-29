# frozen_string_literal: true

require 'rails_helper'
require 'support/active_storage_helpers'

RSpec.describe Api::V1::ListingsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:category) { FactoryBot.create(:category) }
  let(:listing) { FactoryBot.create(:listing, category: category, user: user) }

  # before(:each) do
  #  FactoryBot.create_list(:listing, 4, user: user, category: category)
  # end

  describe '#index' do
    it 'returns a success response' do
      get :index, params: {}
      expect(response).to have_http_status(:success)
    end

    it 'returns a collection of listings' do
      FactoryBot.create_list(:listing, 5, user: user, category: category)
      get :index, params: {}
      expect(JSON.parse(response.body).count).to eq 5
    end

    it 'returns listings with an image' do
      file = fixture_file_upload('spec/fixtures/files/melvin.jpg', 'image/jpg')
      FactoryBot.create(:listing, user: user, category: category, images: file)
      get :index, params: {}

      actual = JSON.parse(response.body)
      expect(actual[0]['images'].count).to eq 1
    end

    it 'returns a listing with multiple images' do
      file = fixture_file_upload('spec/fixtures/files/melvin.jpg', 'image/jpg')
      FactoryBot.create(:listing,
                        user: user,
                        category: category,
                        images: [file, file])

      get :index, params: {}

      actual = JSON.parse(response.body)
      expect(actual[0]['images']).to be_a Array
      expect(actual[0]['images'].count).to eq 2
    end

    it 'returns listings with a category' do
      FactoryBot.create(:listing, user: user, category: category)
      get :index, params: {}

      content = JSON.parse(response.body, symbolize_names: true)
      expect(content[0][:category]).to_not be_nil
    end

    it 'returns listings with a user_id' do
      FactoryBot.create(:listing, user: user, category: category)
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
