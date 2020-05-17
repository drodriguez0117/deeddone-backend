require 'rails_helper'

RSpec.describe Api::V1::ListingsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(:get => '/api/v1/listings').to route_to('api/v1/listings#index')
    end

    it 'routes to #show' do
      expect(:get => '/api/v1/listings/1').to route_to('api/v1/listings#show', :id => '1')
    end

    it 'routes to #create' do
      expect(:post => '/api/v1/listings').to route_to('api/v1/listings#create')
    end

    it 'routes to #update via PUT' do
      expect(:put => '/api/v1/listings/1').to route_to('api/v1/listings#update', :id => '1')
    end

    it 'routes to #update via PATCH' do
      expect(:patch => '/api/v1/listings/1').to route_to('api/v1/listings#update', :id => '1')
    end

    it 'routes to #destroy' do
      expect(:delete => '/api/v1/listings/1').to route_to('api/v1/listings#destroy', :id => '1')
    end

    specify {
      expect(get: api_v1_listings_path).to route_to(controller: 'api/v1/listings',
                                                    action: 'index')}

    specify {
      expect(get: '/api/v1/listings').to route_to(controller: 'api/v1/listings',
                                                  action: 'index')}

    specify {
      expect(get: api_v1_listing_path(1)).to route_to(controller: 'api/v1/listings',
                                                      action: 'show',
                                                      id: '1')}

    specify {
      expect(get: '/api/v1/listings/1').to route_to(controller: 'api/v1/listings',
                                                    action: 'show',
                                                    id: '1')}
  end
end
