FactoryBot.define do
  factory :academy do
    name { Faker::Company.name }
    slug { name.parameterize }
  end
end
