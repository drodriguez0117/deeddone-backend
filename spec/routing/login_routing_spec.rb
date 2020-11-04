require 'rails_helper'

RSpec.describe LoginController, type: :routing do
  describe 'routing' do

    it 'routes to #create' do
      expect(post: '/login').to route_to('login#create')
    end

    it 'routes to #destroy' do
      expect(delete: 'login').to route_to('login#destroy')
    end

  end
end
