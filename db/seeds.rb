# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#

5.times do
  user = User.create(email: Faker::Internet.email,
                     password_digest: BCrypt::Password.create('test'))

  3.times do
    v = user.listings.create(title: Faker::Appliance.equipment,
                         description: Faker::Lorem.sentence(word_count: 8),
                         listing_type: 'offering')

    file_path = 'spec/fixtures/files/melvin.jpg'
    v.images.attach(io: File.open(file_path),
                         filename: 'melvin.jpg',
                         content_type: 'image/jpeg')
  end

  2.times do
    g = user.listings.create(title: Faker::Appliance.equipment,
                         description: Faker::Appliance.equipment,
                         listing_type: 'request')

    #file_path = 'spec/fixtures/files/melvin.jpg'
    #g.images.attach(io: File.open(file_path),
    #                filename: 'melvin.jpg',
    #                content_type: 'image/jpeg')
  end
end
