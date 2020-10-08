require 'rails_helper'

RSpec.describe RefreshController, type: :routing do
  describe 'routing' do

    it 'routes to #create' do
      expect(post: '/refresh').to route_to('refresh#create')
    end
  end
end