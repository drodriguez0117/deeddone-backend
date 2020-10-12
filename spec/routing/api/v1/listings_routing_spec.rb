require 'rails_helper'

RSpec.describe Api::V1::ListingsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: 'listings').to route_to('api/v1/listings#index')
    end

    it 'routes to #show' do
      expect(get: 'listings/1').to route_to('api/v1/listings#show', id: '1')
    end

    specify {
      expect(get: listings_path).to route_to(controller: 'api/v1/listings',
                                                    action: 'index')}

    specify {
      expect(get: 'listings').to route_to(controller: 'api/v1/listings',
                                                  action: 'index')}

    specify {
      expect(get: listing_path(1)).to route_to(controller: 'api/v1/listings',
                                                      action: 'show',
                                                      id: '1')}

    specify {
      expect(get: 'listings/1').to route_to(controller: 'api/v1/listings',
                                                    action: 'show',
                                                    id: '1')}
  end
end
