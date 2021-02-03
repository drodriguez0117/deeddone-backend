
require 'rails_helper'
require 'support/active_storage_helpers'

RSpec.describe Api::V1::Admin::CategoriesController, type: :controller do
  let(:category) { FactoryBot.create(:category) }

end
