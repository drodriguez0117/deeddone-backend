require 'rails_helper'

RSpec.describe Api::V1::Admin::CategoriesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: 'admin/categories').to route_to('api/v1/admin/categories#index')
    end
  end
end
