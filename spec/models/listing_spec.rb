require 'rails_helper'

RSpec.describe Listing, type: :model do
  #let!(:listing) { FactoryBot.create(:listing) }
  let!(:user) { FactoryBot.create(:user) }

  it 'is valid with valid attributes' do
    expect(Listing.new(FactoryBot.attributes_for(:listing, user: user))).to be_valid
  end
  it 'is valid with valid attributes with image' do
    expect(Listing.new(FactoryBot.attributes_for(:listing,
                                                 images: :with_image,
                                                 user: user))).to be_valid
  end

  it 'is valid with valid attributes with multiple images' do
    expect(Listing.new(FactoryBot.attributes_for(:listing,
                                                 images: [ :with_image, :with_image ],
                                                 user: user))).to be_valid
  end

  it 'is not valid without a title' do
    expect(Listing.new(FactoryBot.attributes_for(:listing, title: nil)
                      )).to_not be_valid
  end
  it 'is not valid without a description' do
    expect(Listing.new(FactoryBot.attributes_for(:listing, description: nil)
                      )).to_not be_valid
  end
  it 'is not valid without a listing_type_id' do
    expect(Listing.new(FactoryBot.attributes_for( :listing, listing_type_id: nil)
                      )).to_not be_valid
  end
end