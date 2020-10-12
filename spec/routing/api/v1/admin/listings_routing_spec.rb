require 'rails_helper'

RSpec.describe Api::V1::Admin::ListingsController, type: :routing do
  describe 'routing' do

    it 'routes to #show' do
      expect(get: 'admin/listings/1').to route_to('api/v1/admin/listings#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: 'admin/listings').to route_to('api/v1/admin/listings#create')
    end

    it 'routes to #update via PUT' do
      expect(put: 'admin/listings/1').to route_to('api/v1/admin/listings#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: 'admin/listings/1').to route_to('api/v1/admin/listings#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: 'admin/listings/1').to route_to('api/v1/admin/listings#destroy', id: '1')
    end

    specify {
      expect(get: admin_listing_path(1)).to route_to(controller: 'api/v1/admin/listings',
                                                      action: 'show',
                                                      id: '1')}

    specify {
      expect(get: 'admin/listings/1').to route_to(controller: 'api/v1/admin/listings',
                                                    action: 'show',
                                                    id: '1')}
  end
end
