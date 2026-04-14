FactoryBot.define do
  factory :enrollment do
    association :student
    association :plan
    started_at { Date.today }
    status     { :active }
  end
end
