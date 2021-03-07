require 'rails_helper'
require 'support/active_storage_helpers'

RSpec.describe 'Api::V1::Admin::ListingImages', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:category) { FactoryBot.create(:category) }
  let(:exchange) { FactoryBot.create(:exchange) }

  let(:file1) { fixture_file_upload('spec/fixtures/files/melvin.jpg', 'image/jpg') }
  let(:file2) { fixture_file_upload('spec/fixtures/files/chaumont.png', 'image/jpg') }
  let(:file3) { fixture_file_upload('spec/fixtures/files/watch.jpg', 'image/jpg') }

  let(:valid_attributes) do
    FactoryBot.attributes_for(:listing, category_id: category.id, exchange_id: exchange.id)
  end

  let(:auth_token) do
    payload = { user_id: user.id }
    secret = Rails.application.credentials.secret_jwt_encryption_key
    JWT.encode(payload, secret, 'HS256')
  end

  let(:token) do
    { 'Authorization' => "Bearer #{auth_token}" }
  end

  describe 'POST admin/listing_images' do

    it 'adds a new image to a listing' do
      # create the user listing
      post '/admin/listings', params: { listing: valid_attributes }, headers: token

      listing = JSON.parse(response.body, symbolize_names: true)
      @listing_id = listing[:id]

      # update listing with new image
      post "/admin/listings/#{@listing_id}/listing_images/",
           params: { images: [file1], listing_id: @listing_id },
           headers: token

      expect(response).to have_http_status(:ok)

      # this isn't right, there will always be at least one
      # image - if one doesn't exist on the listing, the listing
      # image defaults to the category default image
      content = JSON.parse(response.body, symbolize_names: true)
      expect(content[:images]).to_not be_nil

      # but, this is right because category default images
      # are not saved to the db. nice.
      expect(ActiveStorage::Attachment.count).to eq(1)
    end

    it 'adds a new image to a listing that contains images' do
      listing = FactoryBot.create(:listing,
                                  category_id: category.id,
                                  exchange_id: exchange.id,
                                  images: [file1, file2],
                                  user: user)

      post "/admin/listings/#{listing.id}/listing_images/", params: { images: [file3] }, headers: token

      expect(response).to have_http_status(:ok)

      content = JSON.parse(response.body, symbolize_names: true)
      expect(content[:images]).to_not be_nil
      expect(ActiveStorage::Attachment.count).to eq(3)
    end

    it 'adds multiple images to a listing' do
      listing = FactoryBot.create(:listing,
                                  category_id: category.id,
                                  exchange_id: exchange.id,
                                  images: [file1],
                                  user: user)

      post "/admin/listings/#{listing.id}/listing_images/", params: { images: [file2, file3] }, headers: token

      expect(response).to have_http_status(:ok)

      content = JSON.parse(response.body, symbolize_names: true)
      expect(content[:images]).to_not be_nil
      expect(ActiveStorage::Attachment.count).to eq(3)
    end
  end

  describe 'DELETE admin/listing_images' do

    it 'deletes an existing listing image' do
      listing = FactoryBot.attributes_for(:listing,
                                          category_id: category.id,
                                          exchange_id: exchange.id,
                                          images: [file1],
                                          user: user)

      # create the user listing
      post '/admin/listings', params: { listing: listing }, headers: token

      listing = JSON.parse(response.body, symbolize_names: true)
      @listing_id = listing[:id]
      @key = listing[:images][0][:image]

      escaped = URI.escape(@key, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))

      delete "/admin/listings/#{listing[:id]}/listing_images/#{escaped}",
             params: {},
             headers: token

      content = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(:ok)
      # listing should have a default image when there are no user images
      expect(content[:images][0][:image]).to eq("/images/#{category.default_image_path}")
      expect(ActiveStorage::Attachment.count).to eq(0)
    end

    it 'deletes an image from a listing with multiple images' do
      listing = FactoryBot.attributes_for(:listing,
                                          category_id: category.id,
                                          exchange_id: exchange.id,
                                          images: [file1, file2],
                                          user: user)

      # create the user listing
      post '/admin/listings', params: { listing: listing }, headers: token
      expect(ActiveStorage::Attachment.count).to eq(2)

      listing = JSON.parse(response.body, symbolize_names: true)
      key = URI.escape(listing[:images][0][:image], Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))

      delete "/admin/listings/#{listing[:id]}/listing_images/#{key}", params: {}, headers: token

      expect(response).to have_http_status(:ok)

      content = JSON.parse(response.body, symbolize_names: true)
      expect(content[:images].length).to eq(1)
      expect(ActiveStorage::Attachment.count).to eq(1)
    end
  end
end