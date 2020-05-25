require 'rails_helper'

RSpec.describe SigninController, type: :routing do
  describe 'routing' do

    it 'routes to #create' do
      expect(post: '/signin').to route_to('signin#create')
    end

    it 'routes to #destroy' do
      expect(delete: 'signin').to route_to('signin#destroy')
    end

  end
end
