require 'date'

FactoryBot.define {
  factory :listing do
    title { 'Shoes' }
    description { 'tiny shoes' }
    listing_type { 'offering' }
    expired_at { (Date.today + 30.days).to_s }
    user { nil }

    trait :with_image do
      after :build do |listing|
        file_path = 'spec/fixtures/files/melvin.jpg'
        listing.image.attach(io: File.open(file_path),
                             filename: 'melvin.jpg',
                             content_type: 'image/jpeg')
      end
    end

    # create multiple listings
    #
  end
}