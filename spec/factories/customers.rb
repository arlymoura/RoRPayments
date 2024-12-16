FactoryBot.define do
  factory :customer do
    association :user
    name { Faker::Name.name }
    email { Faker::Internet.email }
    external_id { SecureRandom.uuid }
  end

  trait :without_user do
    user { nil }
  end
end
