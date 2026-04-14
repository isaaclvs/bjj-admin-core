FactoryBot.define do
  factory :plan do
    association :academy
    name        { "Plano #{Faker::Lorem.word.capitalize}" }
    price_cents { 15000 }
    interval    { :monthly }
    active      { true }
  end
end
