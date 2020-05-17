require 'rails_helper'
require 'pp'

RSpec.describe Listing, type: :model do
  let(:listing) { create :listing }
  it 'is valid with valid attributes' do
    expect(Listing.new(FactoryBot.attributes_for(:listing))).to be_valid
  end
  it 'is valid with valid attributes with image' do
    expect(Listing.new(FactoryBot.attributes_for(:listing, image: :with_image)))
  end
  it 'is not valid without a title' do
    expect(Listing.new(FactoryBot.attributes_for(:listing, title: nil))).to_not be_valid
  end
  it 'is not valid without a description' do
    expect(Listing.new(FactoryBot.attributes_for(:listing, description: nil))).to_not be_valid
  end
  it 'is not valid without a listing_type_id' do
    expect(Listing.new(FactoryBot.attributes_for(:listing, listing_type_id: nil))).to_not be_valid
  end
end