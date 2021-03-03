# frozen_string_literal: true

require 'rails_helper'
require 'pp'

RSpec.describe Listing, elasticsearch: true, type: :model do
  let!(:category) { FactoryBot.build(:category) }
  let!(:exchange) { FactoryBot.build(:exchange) }
  let!(:user) { FactoryBot.build(:user) }

  context '#search' do
    before(:each) do
      Listing.create(FactoryBot.attributes_for(:listing,
                                               category: category,
                                               exchange: exchange,
                                               user: user))
      Listing.__elasticsearch__.import force: true
      Listing.__elasticsearch__.refresh_index!
    end

    after(:each) do
      Listing.__elasticsearch__.client.indices.delete index: Listing.index_name
    end

    it 'should have a search index' do
      expect(Listing.__elasticsearch__.index_exists?).to be_truthy
    end

    it 'should index title' do
      expect(Listing.search('Shoes').records.length).to eq(1)
    end

    it 'should index description' do
      expect(Listing.search('velvet').records.length).to eq(1)
    end

    it 'should not return records for nonsense' do
      expect(Listing.search('lost in the flood').records.length).to eq(0)
    end

    it 'should not index category default_image_path' do
      expect(Listing.search('chaumont.png').records.length).to eq(0)
    end

    it 'should handle singular title' do
      expect(Listing.search('shoe').records.length).to eq(1)
    end

    it 'should handle pluralized description' do
      expect(Listing.search('pieces').records.length).to eq(1)
    end

    it 'should only return active listings' do
      Listing.create(FactoryBot.attributes_for(:listing,
                                               is_active: false,
                                               category: category,
                                               exchange: exchange,
                                               user: user))
      Listing.__elasticsearch__.import force: true
      Listing.__elasticsearch__.refresh_index!

      expect(Listing.search_published('velvet').records.length).to eq(1)
    end
  end

  context '#search multiple' do
    before(:each) do
      Listing.create(FactoryBot.attributes_for(:listing,
                                               category: category,
                                               exchange: exchange,
                                               user: user))
      Listing.create(FactoryBot.attributes_for(:listing,
                                               title: 'ashbury park, nj',
                                               description: 'velvet queen of arkansas',
                                               category: category,
                                               exchange: exchange,
                                               user: user))

      Listing.__elasticsearch__.import force: true
      Listing.__elasticsearch__.refresh_index!
    end

    it 'should index listings for title: ashbury' do
      expect(Listing.search('Ashbury').records.length).to eq(1)
    end

    it 'should index listings for title: shoes' do
      expect(Listing.search('shoes').records.length).to eq(1)
    end

    it 'should index multiple listings description' do
      expect(Listing.search('velvet').records.length).to eq(2)
    end

    it 'should index multiple pluralized listing descriptions' do
      expect(Listing.search('velvets').records.length).to eq(2)
    end
  end
end