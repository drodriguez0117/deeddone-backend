FactoryBot.define {
  factory :listing do
    title { 'Shoes' }
    description { 'tiny shoes' }
    listing_type { 'offering' }
    user { nil }
    #category_id factory: :category, id: 4

    trait :with_image do
      after :build do |listing|
        file_path = 'spec/fixtures/files/melvin.jpg'
        listing.image.attach(io: File.open(file_path),
                             filename: 'melvin.jpg',
                             content_type: 'image/jpeg')
      end
    end
  end
}