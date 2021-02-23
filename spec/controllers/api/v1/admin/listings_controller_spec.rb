# frozen_string_literal: true

require 'rails_helper'
require 'support/active_storage_helpers'

RSpec.describe Api::V1::Admin::ListingsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:category) { FactoryBot.create(:category) }
  let(:exchange) { FactoryBot.create(:exchange) }

  let(:valid_attributes) do
    FactoryBot.attributes_for(:listing, category_id: category.id, exchange_id: exchange.id)
  end

  let(:valid_attributes_with_image) do
    FactoryBot.attributes_for(:listing, images: file)
  end

  let(:invalid_attributes) do
    FactoryBot.attributes_for(:listing, title: nil)
  end

  let(:invalid_listing_type) do
    FactoryBot.attributes_for(:listing, listing_type: 'idk')
  end

  let(:auth_token) do
    payload = { user_id: user.id }
    secret = Rails.application.credentials.secret_jwt_encryption_key
    JWT.encode(payload, secret, 'HS256')
  end

  let(:token) do
    { 'Authorization' => "Bearer #{auth_token}" }
  end

  describe '#show' do
    let(:listing) do
      FactoryBot.create(:listing, category: category, exchange: exchange, user: user)
    end

    it 'returns a successful response' do
      request.headers.merge!(token)
      get :show, params: { id: listing.id }
      expect(response).to have_http_status(:ok)
      expect(response).to be_successful
    end
  end

  describe '#create' do
    context 'valid params' do
      it 'creates a new listing' do
        expect do
          request.headers.merge!(token)
          post :create, params: { listing: valid_attributes }
        end.to change(Listing, :count).by(1)
      end

      it 'creates a new listing with an image' do
        file = fixture_file_upload('spec/fixtures/files/melvin.jpg', 'image/jpg')

        expect do
          post :create, params: { listing:
                                    FactoryBot.create(:listing,
                                                      category_id: category.id,
                                                      exchange_id: exchange.id,
                                                      images: [file],
                                                      user: user) }
        end.to change { ActiveStorage::Attachment.count }.by(1)
      end

      it 'creates a new listing with multiple images' do
        file1 = fixture_file_upload('spec/fixtures/files/melvin.jpg', 'image/jpg')
        file2 = fixture_file_upload('spec/fixtures/files/chaumont.png', 'image/png')

        expect do
          post :create, params: { listing:
                                    FactoryBot.create(:listing,
                                                      category_id: category.id,
                                                      exchange_id: exchange.id,
                                                      images: [file1, file2],
                                                      user: user) }
        end.to change { ActiveStorage::Attachment.count }.by(2)
      end

      it 'renders a JSON response with the new listing' do
        request.headers.merge!(token)
        post :create, params: { listing: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'invalid params' do
      it 'renders a JSON response with errors' do
        request.headers.merge!(token)
        post :create, params: { listing: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'invalid listing_type renders JSON response with errors' do
        request.headers.merge!(token)
        post :create, params: { listing: invalid_listing_type }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe '#update' do
    let(:listing) { 
      FactoryBot.create(:listing,
                        category_id: category.id,
                        exchange_id: exchange.id,
                        user: user) }

      FactoryBot.attributes_for(:listing)

    context 'valid params' do
      before (:each) do
        request.headers.merge!(token)
      end

      let(:new_attributes) do
        { title: 'cool title' }
      end

      it 'updates the requested listing' do
        put :update, params: { id: listing.id, listing: new_attributes }
        listing.reload
        expect(response).to have_http_status(:ok)
        expect(listing.title).to eq new_attributes[:title]
      end

      it 'renders a JSON response with the listing' do
        put :update, params: { id: listing.to_param, listing: valid_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'invalid params' do
      before(:each) do
        request.headers.merge!(token)
      end

      it 'renders a JSON response with errors' do
        put :update, params: { id: listing.to_param,
                               listing: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'listing without a listing_type renders a JSON response with errors' do
        put :update, params: { id: listing.to_param,
                               listing: FactoryBot.attributes_for(:listing,
                                                                  listing_type: nil) }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe '#destroy' do
    let!(:listing) do
      FactoryBot.create(:listing,
                        category_id: category.id,
                        exchange_id: exchange.id,
                        user: user)
    end

    it 'destroys the requested listing' do
      expect do
        request.headers.merge!(token)
        delete :destroy, params: { id: listing.id }
      end.to change(Listing, :count).by(-1)
    end
  end
end
