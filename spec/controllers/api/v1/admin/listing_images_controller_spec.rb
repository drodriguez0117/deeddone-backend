require 'rails_helper'

RSpec.describe Api::V1::Admin::ListingImagesController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:category) { FactoryBot.create(:category) }
  let(:exchange) { FactoryBot.create(:exchange) }

  let(:valid_attributes) do
    FactoryBot.attributes_for(:listing, category_id: category.id, exchange_id: exchange.id)
  end

  let(:valid_attributes_with_image) do
    FactoryBot.attributes_for(:listing, images: file)
  end

  let(:auth_token) do
    payload = { user_id: user.id }
    secret = Rails.application.credentials.secret_jwt_encryption_key
    JWT.encode(payload, secret, 'HS256')
  end

  let(:token) do
    { 'Authorization' => "Bearer #{auth_token}" }
  end

  describe '#create' do
    # it 'adds a new image to a listing' do
    #   request.headers.merge!(token)
    #   post :create, params: { listing: valid_attributes }
    #   puts response.to_yaml
    #   # need the listing id
    #   # create a new image: file = fixture_file_upload('spec/fixtures/files/melvin.jpg', 'image/jpg')
    #   # call create
    #   # verify
    # end

    # it 'creates a new listing with an image' do
    #   file = fixture_file_upload('spec/fixtures/files/melvin.jpg', 'image/jpg')
    #   listing = FactoryBot.create(:listing,
    #                               category_id: category.id,
    #                               exchange_id: exchange.id,
    #                               images: [file],
    #                               user: user)
    #   expect do
    #     post :create, params: { listing: listing }
    #   end.to change { ActiveStorage::Attachment.count }.by(1)
    # end
  end

  # describe "GET #update" do
  #   it "returns http success" do
  #     get :update
  #     expect(response).to have_http_status(:success)
  #   end
  # end
end
