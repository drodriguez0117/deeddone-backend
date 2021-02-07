# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
2.times do
  user = User.create(email: Faker::Internet.email,
                     password_digest: BCrypt::Password.create('test'))
  2.times do
    v = user.listings.create(title: Faker::Appliance.equipment,
                             description: Faker::Lorem.sentence(word_count: 8),
                             listing_type: 'offering',
                             category_id: rand(Category.count),
                             exchange_id: rand(Exchange.count),
                             expired_at: (Date.today + 30.days).to_s
                          )
  end
  1.times do
    m = user.listings.create(title: Faker::Appliance.equipment,
                             description: Faker::Lorem.sentence(word_count: 8),
                             listing_type: 'offering',
                             category_id: rand(Category.count),
                             exchange_id: rand(Exchange.count),
                             expired_at: (Date.today + 30.days).to_s
    )
    file_path = 'spec/fixtures/files/melvin.jpg'
    m.images.attach(io: File.open(file_path),
                    filename: 'melvin.jpg',
                    content_type: 'image/jpeg')
  end
  1.times do
    g = user.listings.create(title: Faker::Appliance.equipment,
                             description: Faker::Appliance.equipment,
                             listing_type: 'request',
                             category_id: rand(Category.count),
                             exchange_id: rand(Exchange.count),
                             expired_at: (Date.today + 30.days).to_s)
  end
end
