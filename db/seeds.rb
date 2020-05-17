# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
ListingType.create([{ name: 'offer',
                                      description: 'giving',
                                      is_active: 1 },
                                    { name: 're quest',
                                      description: 'getting',
                                      is_active: 1 }
                                   ])

Listing.create([{ title: '5000 Pencils',
                             description: '50 boxes of type 2 pencils',
                             listing_type_id: 1 },
                           {title: 'Size 11 Construction Boots',
                            description: 'Looking for boots for work',
                            listing_type_id: 2 }
                          ])