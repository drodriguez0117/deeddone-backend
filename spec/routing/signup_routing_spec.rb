require 'rails_helper'

RSpec.describe SignupController, type: :routing do
  describe 'routing' do

    it 'routes to #create' do
      expect(post: '/signup').to route_to('signup#create')
    end
  end
end