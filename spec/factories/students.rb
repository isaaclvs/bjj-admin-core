FactoryBot.define do
  factory :student do
    association :academy
    name   { Faker::Name.name }
    cpf    { Faker::Number.number(digits: 11).to_s }
    phone  { Faker::PhoneNumber.cell_phone }
    email  { Faker::Internet.email }
    belt   { :white }
    status { :active }

    trait :at_risk do
      after(:create) do |student|
        create(:health_record, student: student, risk_flag: true)
      end
    end
  end
end
