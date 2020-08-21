FactoryBot.define do
  factory :user do
    telegram_id { Faker::Alphanumeric.alpha(number: 10) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
  end
end
