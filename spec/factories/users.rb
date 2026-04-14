FactoryBot.define do
  factory :user do
    association :academy
    email    { Faker::Internet.unique.email }
    password { "password123" }
    role     { :owner }

    trait :teacher do
      role { :teacher }
    end
  end
end
