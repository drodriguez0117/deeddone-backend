# frozen_string_literal: true

require 'rails_helper'
require 'pp'

RSpec.describe Listing, type: :model do
  let!(:category) { FactoryBot.build(:category) }
  let!(:exchange) { FactoryBot.build(:exchange) }
  let!(:user) { FactoryBot.build(:user) }

  context 'creation' do
    subject { FactoryBot.build(:listing, category: category, exchange: exchange, user: user) }
    it { should be_valid }
  end

  context 'validation' do
    subject { FactoryBot.build(:listing) }

    it { should fail_with_null(:title) }
    it { should fail_with_null(:listing_type) }
    it { should fail_with_null(:category) }
    it { should fail_with_null(:exchange) }
    it { should fail_with_null(:user_id) }

    it 'is valid with title length less than thirty chars' do
      title = 'short title'
      expect(Listing.new(FactoryBot.attributes_for(:listing,
                                                   title: title,
                                                   category: category,
                                                   exchange: exchange,
                                                   user: user))).to be_valid
    end

    it 'is not valid with title length greater than thirty chars' do
      title = 'long title for testing the length.'
      expect(Listing.new(FactoryBot.attributes_for(:listing,
                                                   title: title,
                                                   user: user))).not_to be_valid
    end

    it 'is valid with description less than 200 chars' do
      description = 'NEW: Added default "Header row fixed" setting
        NEW: Support "Comment with line comment" #247
				FIX: "Value coloring" change not applied to open files'

      expect(Listing.new(FactoryBot.attributes_for(:listing,
                                                   description: description,
                                                   category: category,
                                                   exchange: exchange,
                                                   images: :with_image,
                                                   user: user))).to be_valid
    end

    it 'is not valid with description greater than 200 chars' do
      description = 'NEW: Added default "Header row fixed" setting
				NEW: Support "Comment with line comment" #247
				FIX: "Value coloring" change not applied to open files
        Customize plugin settings: Editor/General, Color Scheme, Formatting
				Visit the CSV Plugin GitHub to read more about the available features
        & settings, submit issues & feature request, or show your support by
        rating this plugin'

      expect(Listing.new(FactoryBot.attributes_for(:listing,
                                                   description: description,
                                                   images: :with_image,
                                                   user: user))).not_to be_valid
    end

    it 'is valid with valid attributes' do
      expect(Listing.new(FactoryBot.attributes_for(:listing,
                                                   category: category,
                                                   exchange: exchange,
                                                   user: user))).to be_valid
    end

    it 'is valid with valid attributes with image' do
      expect(Listing.new(FactoryBot.attributes_for(:listing,
                                                   category: category,
                                                   exchange: exchange,
                                                   images: :with_image,
                                                   user: user))).to be_valid
    end

    it 'is valid with valid attributes with multiple images' do
      expect(Listing.new(FactoryBot.attributes_for(:listing,
                                                   category: category,
                                                   exchange: exchange,
                                                   images: %i[with_image with_image],
                                                   user: user))).to be_valid
    end
  end

  context '#images_or_default' do
    let(:simple_listing)      { FactoryBot.build(:listing, category: category, user: user) }
    let(:category_two)        { FactoryBot.build(:category, default_image_path: 'fixtures/files/melvin.jpg') }
    let(:simple_listing_two)  { FactoryBot.build(:listing, category: category_two, user: user) }

    let(:category_asset_default_path)     { ActionController::Base.helpers.asset_url(category.default_image_path, type: :image) }
    let(:category_two_asset_default_path) { ActionController::Base.helpers.asset_url(category_two.default_image_path, type: :image) }

    # let(:image_listing) { FactoryBot.build(:listing, category: category, user: user, images: []) }

    it 'should return a default image url with a valid structure' do
      expect(simple_listing.images_or_default).to be_a Array
      expect(simple_listing.images_or_default.count).to eq 1
      expect(simple_listing.images_or_default[0].key?(:image)).to eq true
    end

    it 'should return a default image url from the category' do
      expect(simple_listing.images_or_default[0][:image]).to_not eq category_two_asset_default_path
      expect(simple_listing.images_or_default[0][:image]).to eq category_asset_default_path

      expect(simple_listing_two.images_or_default[0][:image]).to_not eq category_asset_default_path
      expect(simple_listing_two.images_or_default[0][:image]).to eq category_two_asset_default_path
    end

    it 'should return a valid structure for listing images' do
      file = fixture_file_upload('spec/fixtures/files/melvin.jpg', 'image/jpg')
      listing = FactoryBot.create(:listing, user: user, category: category, exchange: exchange, images: [file])

      expect(listing.images_or_default).to be_a Array
      expect(listing.images_or_default[0].key?(:image)).to eq true
    end

    it 'should return a listing image' do
      file = fixture_file_upload('spec/fixtures/files/melvin.jpg', 'image/jpg')
      listing = FactoryBot.create(:listing, user: user, category: category, exchange: exchange, images: [file])

      expect(listing.images_or_default.count).to eq 1
      expect(listing.images_or_default[0][:image]).to_not eq category_asset_default_path
    end

    it 'should return listing images' do
      file = fixture_file_upload('spec/fixtures/files/melvin.jpg', 'image/jpg')
      listing = FactoryBot.build(:listing, user: user, category: category, exchange: exchange, images: [file, file])

      expect(listing.images_or_default.count).to eq 2
    end
  end

  context '#as_json' do
    let(:image_listing) { FactoryBot.create(:listing, category: category, user: user, images: []) }

    it 'should create object with image'
    it 'should create object without image'
  end
end
