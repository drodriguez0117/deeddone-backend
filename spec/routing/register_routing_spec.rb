require 'rails_helper'

RSpec.describe RegisterController, type: :routing do
  describe 'routing' do

    it 'routes to #create' do
      expect(post: '/register').to route_to('register#create')
    end
  end
end