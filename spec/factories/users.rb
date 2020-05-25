FactoryBot.define do
  factory :user do
    email { 'user@domain.com' }
    password_digest { '123test' }
  end
end
