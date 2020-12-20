require 'rails_helper'
require 'pp'

RSpec.describe Listing, type: :model do
  let!( :category) { FactoryBot.build(:category) }
  let!(:user) { FactoryBot.build(:user) }

  context 'creation' do
    subject { FactoryBot.build(:listing, category: category, user: user) }
    it { should be_valid }
  end

  context 'validation' do
    subject { FactoryBot.build(:listing) }

    it { should fail_with_null(:title) }
    it { should fail_with_null(:listing_type) }
    it { should fail_with_null(:category_id) }

    it 'is valid with title length less than thirty chars' do
      title = 'short title'
      expect(Listing.new(FactoryBot.attributes_for(:listing,
                                                   title: title,
                                                   category: category,
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
                                                   images: :with_image,
                                                   user: user))).to be_valid
    end

    it 'is not valid with description greater than 200 chars' do

      description = 'NEW: Added default "Header row fixed" setting
				NEW: Support "Comment with line comment" #247
				FIX: "Value coloring" change not applied to open files
        Customize plugin settings: Editor/General, Color Scheme, Formatting
				Visit the CSV Plugin GitHub to read more about the available features & settings,
        submit issues & feature request, or show your support by rating this plugin'

      expect(Listing.new(FactoryBot.attributes_for(:listing,
                                                   description: description,
                                                   images: :with_image,
                                                   user: user))).not_to be_valid
    end

    it 'is valid with valid attributes' do
      expect(Listing.new(FactoryBot.attributes_for(:listing,
                                                   category: category,
                                                   user: user))).to be_valid
    end

    it 'is valid with valid attributes with image' do
      expect(Listing.new(FactoryBot.attributes_for(:listing,
                                                   category: category,
                                                   images: :with_image,
                                                   user: user))).to be_valid
    end

    it 'is valid with valid attributes with multiple images' do
      expect(Listing.new(FactoryBot.attributes_for(:listing,
                                                   category: category,
                                                   images: %i[with_image with_image],
                                                   user: user))).to be_valid
    end
  end

  context '#images_or_default' do
    it 'should return image string when using default'
    it 'should return images'
  end

  context '#as_json' do
    it 'should create object with image'
    it 'should create object without image'
  end
end