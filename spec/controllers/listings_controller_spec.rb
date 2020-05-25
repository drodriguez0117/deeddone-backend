require 'rails_helper'
require 'support/active_storage_helpers'
require 'pp'

RSpec.describe Api::V1::ListingsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  let(:valid_attributes) {
    FactoryBot.attributes_for(:listing)
  }

  let(:valid_attributes_with_image) {
    FactoryBot.attributes_for(:listing, images: file)
  }

  let(:invalid_attributes) {
    FactoryBot.attributes_for(:listing, title: nil)
  }

  before do
    #JWTSessions.access_exp_time = 0
    payload = { user_id: user.id }
    session = JWTSessions::Session.new(payload: payload)
    #session = JWTSessions::Session.new(payload: payload,
    #                                   refresh_by_access_allowed: true )
    @tokens = session.login
    #JWTSessions.access_exp_time = 3600
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ListingsController. Be sure to keep this updated too.
  #let(:valid_session) { {} },.

  describe 'GET #index' do
    it 'returns a success response' do
      request.cookies[JWTSessions.access_cookie] = @tokens[:access]

      get :index, params: {}
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    let!(:listing) { FactoryBot.create(:listing, user: user) }

    it 'returns a success response' do
      request.cookies[JWTSessions.access_cookie] = @tokens[:access]

      get :show, params: { id: listing.id }
      expect(response).to have_http_status(:ok)
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do

      it 'creates a new listing' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        request.headers[JWTSessions.csrf_header] = @tokens[:csrf]

        expect {
          post :create, params: { listing: valid_attributes }
        }.to change(Listing, :count).by(1)
      end

      it 'creates a new listing with an image' do
        file = fixture_file_upload('spec/fixtures/files/melvin.jpg', 'image/jpg')

        expect {
          post :create, params: { listing: FactoryBot.create(:listing, images: [file], user: user) }
        }.to change{ ActiveStorage::Attachment.count }.by(1)
      end

      it 'creates a new listing with multiple images' do
        file1 = fixture_file_upload('spec/fixtures/files/melvin.jpg', 'image/jpg')
        file2 = fixture_file_upload('spec/fixtures/files/chaumont.png', 'image/png')

        expect {
          post :create, params: { listing: FactoryBot.create(:listing, images: [file1, file2], user: user) }
        }.to change{ ActiveStorage::Attachment.count }.by(2)
      end

      it 'renders a JSON response with the new listing' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        request.headers[JWTSessions.csrf_header] = @tokens[:csrf]

        post :create, params: { listing: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new listing' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        request.headers[JWTSessions.csrf_header] = @tokens[:csrf]

        post :create, params: { listing: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'PUT #update' do
    let!(:listing) { FactoryBot.create(:listing, user: user)}

    let!(:listing_with_files) {
      file1 = fixture_file_upload('spec/fixtures/files/melvin.jpg', 'image/jpg')
      file2 = fixture_file_upload('spec/fixtures/files/chaumont.png', 'image/png')

      FactoryBot.attributes_for(:listing,
                                images: [file1, file2])
    }

    context 'with valid params' do

      let(:new_attributes) {
        { title: 'cool title' }
      }

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
    end

    it 'renders a JSON response for a listing with multiple images' do
      request.cookies[JWTSessions.access_cookie] = @tokens[:access]
      request.headers[JWTSessions.csrf_header] = @tokens[:csrf]

      put :update, params: { id: listing.to_param,
                             listing: listing_with_files }
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the listing' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        request.headers[JWTSessions.csrf_header] = @tokens[:csrf]

        put :update, params: { id: listing.to_param,
                               listing: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'renders a JSON response with errors for listing without type id' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        request.headers[JWTSessions.csrf_header] = @tokens[:csrf]

        put :update, params: { id: listing.to_param,
                               listing: FactoryBot.attributes_for(:listing,
                                                                  listing_type_id: nil)}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:listing) { FactoryBot.create(:listing, user: user) }

    it 'destroys the requested listing' do
      request.cookies[JWTSessions.access_cookie] = @tokens[:access]
      request.headers[JWTSessions.csrf_header] = @tokens[:csrf]

      expect {
        delete :destroy, params: { id: listing.id }
      }.to change(Listing, :count).by(-1)
    end
  end

end
