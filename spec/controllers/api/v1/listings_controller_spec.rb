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

  let(:invalid_listing_type) {
    FactoryBot.attributes_for(:listing, listing_type: 'idk')
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

end
