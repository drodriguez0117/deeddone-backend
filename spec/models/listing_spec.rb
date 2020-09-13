require 'rails_helper'

RSpec.describe Listing, type: :model do
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

  it { should fail_with_null(:title) }
  it { should fail_with_null(:listing_type) }

  # use context for validation
end