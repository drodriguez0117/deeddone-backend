# frozen_string_literal: true

require 'rails_helper'
require 'support/active_storage_helpers'

RSpec.describe Api::V1::Admin::ListingsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:category) { FactoryBot.create(:category) }

  let(:valid_attributes) do
    FactoryBot.attributes_for(:listing, category_id: category.id)
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

  before do
    payload = { user_id: user.id }
    session = JWTSessions::Session.new(payload: payload)
    @tokens = session.login
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ListingsController. Be sure to keep this updated too.
  # let(:valid_session) { {} },.

  describe '#show' do
    let(:listing) do
      FactoryBot.create(:listing, category: category, user: user)
    end

    it 'returns a successful response' do
      request.cookies[JWTSessions.access_cookie] = @tokens[:access]

      get :show, params: { id: listing.id }
      expect(response).to have_http_status(:ok)
      expect(response).to be_successful
    end
  end

  describe '#create' do
    context 'valid params' do
      it 'creates a new listing' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        request.headers[JWTSessions.csrf_header] = @tokens[:csrf]

        expect do
          post :create, params: { listing: valid_attributes }
        end.to change(Listing, :count).by(1)
      end

      it 'creates a new listing with an image' do
        file = fixture_file_upload('spec/fixtures/files/melvin.jpg', 'image/jpg')

        expect do
          post :create, params: { listing:
                                    FactoryBot.create(:listing,
                                                      category_id: category.id,
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
                                                      images: [file1, file2],
                                                      user: user) }
        end.to change { ActiveStorage::Attachment.count }.by(2)
      end

      it 'renders a JSON response with the new listing' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        request.headers[JWTSessions.csrf_header] = @tokens[:csrf]

        post :create, params: { listing: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'invalid params' do
      it 'renders a JSON response with errors' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        request.headers[JWTSessions.csrf_header] = @tokens[:csrf]

        post :create, params: { listing: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'invalid listing_type renders JSON response with errors' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        request.headers[JWTSessions.csrf_header] = @tokens[:csrf]

        post :create, params: { listing: invalid_listing_type }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe '#update' do
    let(:listing) { FactoryBot.create(:listing, category_id: category.id, user: user) }
    let(:listing_with_files) do
      file1 = fixture_file_upload('spec/fixtures/files/melvin.jpg', 'image/jpg')
      file2 = fixture_file_upload('spec/fixtures/files/chaumont.png', 'image/png')

      FactoryBot.attributes_for(:listing,
                                images: [file1, file2])
    end

    context 'valid params' do
      let(:new_attributes) do
        { title: 'cool title' }
      end

      it 'updates the requested listing' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        request.headers[JWTSessions.csrf_header] = @tokens[:csrf]

        put :update, params: { id: listing.id, listing: new_attributes }
        listing.reload
        expect(response).to have_http_status(:ok)
        expect(listing.title).to eq new_attributes[:title]
      end

      it 'renders a JSON response with the listing' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        request.headers[JWTSessions.csrf_header] = @tokens[:csrf]

        put :update, params: { id: listing.to_param, listing: valid_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'renders a JSON response for a listing with image' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        request.headers[JWTSessions.csrf_header] = @tokens[:csrf]

        put :update, params: { id: listing.to_param,
                               listing: FactoryBot.attributes_for(:listing, image: :with_image) }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'renders a JSON response for a listing with multiple images' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        request.headers[JWTSessions.csrf_header] = @tokens[:csrf]

        put :update, params: { id: listing.to_param,
                               listing: listing_with_files }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'invalid params' do
      it 'renders a JSON response with errors' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        request.headers[JWTSessions.csrf_header] = @tokens[:csrf]

        put :update, params: { id: listing.to_param,
                               listing: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'listing without a listing_type renders a JSON response with errors' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        request.headers[JWTSessions.csrf_header] = @tokens[:csrf]

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
                        user: user)
    end

    it 'destroys the requested listing' do
      request.cookies[JWTSessions.access_cookie] = @tokens[:access]
      request.headers[JWTSessions.csrf_header] = @tokens[:csrf]

      expect do
        delete :destroy, params: { id: listing.id }
      end.to change(Listing, :count).by(-1)
    end
  end
end
