require 'rails_helper'
require 'support/active_storage_helpers'

RSpec.describe Api::V1::ListingsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Listing. As you add validations to Listing, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    FactoryBot.attributes_for(:listing)
  }

  let(:valid_attributes_with_image) {
    FactoryBot.attributes_for(:listing, image: file)
  }

  let(:invalid_attributes) {
    FactoryBot.attributes_for(:listing, title: nil)
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ListingsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      listing = FactoryBot.create(:listing)
      get :show, params: { id: listing.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do

      it 'creates a new listing' do
        expect {
          post :create, params: { listing: valid_attributes }
        }.to change(Listing, :count).by(1)
      end

      def trigger
        file = fixture_file_upload('spec/fixtures/files/melvin.jpg', 'image/jpg')
        post :create, params: { listing: FactoryBot.attributes_for(:listing, image: file) }
      end

      it 'creates a new listing with an image' do
        # set attributes for each of the factories by passing hash
        # this uses the listings.factory with_image trait
        expect { trigger }.to change{ ActiveStorage::Attachment.count }.by(1)
      end

      it 'renders a JSON response with the new listing' do
        post :create, params: { listing: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
          #expect(response.location).to eq(api_v1_listing_url(Listing.last))
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new listing' do
        post :create, params: { listing: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do

      it 'updates the requested listing' do
        listing = FactoryBot.create(:listing)
        put :update, params: { id: listing.to_param,
                               listing: FactoryBot.attributes_for(:listing,
                                                                  description: 'updated description') }, session: valid_session
        listing.reload
        expect(response).to have_http_status(:ok)
      end

      it 'renders a JSON response with the listing' do
        listing = FactoryBot.create(:listing)
        put :update, params: { id: listing.to_param,
                               listing: FactoryBot.attributes_for(:listing) }, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'renders a JSON response for a listing with image' do
        file = fixture_file_upload('spec/fixtures/files/melvin.jpg', 'image/jpg')
        listing = FactoryBot.create(:listing, image: file)
        put :update, params: { id: listing.to_param,
                               listing: FactoryBot.attributes_for(:listing, image: file) }, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the listing' do
        listing = Listing.create! valid_attributes
        put :update, params: { id: listing.to_param,
                               listing: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested listing' do
      listing = Listing.create! valid_attributes
      expect {
        delete :destroy, params: { id: listing.to_param }, session: valid_session
      }.to change(Listing, :count).by(-1)
    end
  end

end
