FactoryBot.define {
  factory :category do
    name { 'animal' }
    default_image_path { 'fixtures/files/chaumont.png'}
    is_active { true }
  end
}
